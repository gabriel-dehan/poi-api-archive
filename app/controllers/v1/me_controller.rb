class V1::MeController < ApplicationController
  access_level :public

  def show
  end

  def initial_data
    # initial_data is show but paginated
    render :initial_data 
  end

  def events
    @period = params[:period] || "global"

    check_param!(:period) { |per| ["global", "month", "week"].include?(per) }

    @history = @user.events.order(datetime: :desc).page(params[:page]).per(params[:per_page] || 50)
  end

  def impacts 
  end

  def friends 
    @friends = @user.friends 
    @invitations = @user.invitees
    @suggested_friends = @user.friends_suggestions
  end

  def create_invite
    name, phone_number = require_params!(:name, :phone_number)
    @invitation = @user.invitees.create!({ full_name: name, phone_number: phone_number }) 

    TwilioSMSHandler.call(@invitation.phone_number, I18n.t('sms.invite', receiver: @invitation.full_name, sender: @user.full_name, referral: @user.referral_code))

    if @user.invitees.count == 1 
      # Only the first invitee
      Analytics.track({
        user_id: current_user.id,
        event: 'First Contact Invited',
        properties: { name: @invitation.full_name, phoneNumber: @invitation.phone_number }
      })
    else 
      Analytics.track({
        user_id: current_user.id,
        event: 'Contact Invited',
        properties: { name: @invitation.full_name, phoneNumber: @invitation.phone_number }
      })
    end

    render :friends_success
  end

  def device_contacts 
    contacts_list = params[:_json].map { |c| { name: c[:name], phone_number: PhonyRails.normalize_number(c[:phone_number], country_code: "FR")}}

    potential_friends = User.where(phone_number: contacts_list.map { |c| c[:phone_number]})

    if @user.known_contacts.empty?
      # Only the first time
      Analytics.track({
        user_id: current_user.id,
        event: 'First Contact List Received'
      })
    else
      Analytics.track({
        user_id: current_user.id,
        event: 'Contact List Received'
      })
    end

    potential_friends.each do |user| 
      @user.known_contacts.find_or_create_by(contact: user)
    end 

  end

  def add_friend
    id = require_params!(:id)
    friend = User.find(id)

    @friendship = @user.befriend(friend)

    Analytics.track({
      user_id: current_user.id,
      event: 'Friend Added',
      properties: { email: friend.email }
    })

    render :friends_success
  end

  def remove_friend
    id = require_params!(:id)
    @user.unfriend(User.find(id))

    render :friends_success
  end

  def challenges
  end

  def challenge_friend
    phone_number, category, timeframe, goal = require_params!(:phone_number, :category, :timeframe, :goal)
    contact_name = params[:contact_name]
    phone = PhonyRails.normalize_number(phone_number, country_code: "FR")

    @challenge = @user.given_friends_challenges.where(challenged_phone_number: phone).where(status: ["pending", "accepted"]).first
    if @challenge 
      raise ActionController::BadRequest.new(I18n.t("errors.challenges.exists"))
    end

    challenged = User.find_by(phone_number: phone)

    @challenge = @user.given_friends_challenges.create!({
      # TODO (L): Handle find_by phone number with country codes and such
      challenged: challenged,
      challenged_name: contact_name,
      challenged_phone_number: phone,
      category: category,
      timeframe: timeframe,
      goal: goal,
      status: "pending"
    })

    # If we are challenging a user that is not found in Poi's database
    if !challenged 
      TwilioSMSHandler.call(@challenge.challenged_phone_number, I18n.t('sms.challenge', receiver: contact_name, sender: @user.full_name, referral: @user.referral_code))
    end

    Analytics.track({
      user_id: current_user.id,
      event: 'Challenge Sent',
      properties: { 
        sentToRegisteredUser: !!challenged,
        toEmail: challenged ? challenged.email : 'N/A',
        toPhoneNumber: phone        
      }
    })
  end

  def accept_challenge 
    @challenge = FriendsChallenge.find(params[:id])
    #raise ActiveRecord::RecordNotFound.new("Couldn't find the challenge with id #{params[:id]}") unless @challenge

    @challenge.update({ status: "accepted" })

    Analytics.track({
      user_id: current_user.id,
      event: 'Challenge Accepted',
      properties: { 
        fromEmail: @challenge.challenger.email,
        fromPhoneNumber: @challenge.challenger.phone_number        
      }
    })

    render :challenge_friend
  end

  def deny_challenge 
    @challenge = FriendsChallenge.find(params[:id])
    #raise ActiveRecord::RecordNotFound.new("Couldn't find the challenge with id #{params[:id]}") unless @challenge

    @challenge.update({ status: "rejected" })

    render :challenge_friend
  end

  def perks
  end

  def select_perk
    id = require_params!(:id)

    perk = Perk.find(id)

    @selected_perk = @user.earned_perks.active.find_by(perk_id: perk.id)
    if @selected_perk
      raise ActionController::BadRequest.new(I18n.t("errors.perks.already_available"))
    else
      raise ActionController::BadRequest.new(I18n.t("errors.perks.insufficient_funds")) if @user.impact.current_points_cents < perk.price_cents

      @selected_perk = @user.earned_perks.create({
        perk: perk
      })
    end

    Analytics.track({
      user_id: current_user.id,
      event: 'POI Spent',
      properties: { 
        type: 'perk',
        amount: perk.price
      }
    })
  end

  def campaigns
  end

  def fund_campaign 
    id, amount = require_params!(:id, :amount)
    amount_cents = (amount.to_f * 100).to_i

    raise ActionController::BadRequest.new(I18n.t("errors.fundings.insufficient_funds")) if @user.impact.current_points_cents < amount_cents

    @funding = @user.fundings.create!({
      campaign: Campaign.find(id),
      amount_cents: amount_cents
    })

    Analytics.track({
      user_id: current_user.id,
      event: 'POI Spent',
      properties: { 
        type: 'project',
        amount: amount_cents / 100.0
      }
    })
  end

  def applications 
    @connected_apps = @user.connected_applications.page(params[:page]).per(params[:per_page] || 20)
  end

  def connect 
    id, email, encrypted_password = require_params!(:id, :email, :encrypted_password)

    @connection = @user.connected_applications.where(application_id: id).first_or_initialize do |connection|
      connection.email = email
      connection.status = "connected"
    end

    @connection.encrypted_password = encrypted_password
    @connection.status = "connected" if @connection.disconnected?

    @connection.save! if @connection.validate_auth!

    @connected_apps = @user.connected_applications.page(params[:page]).per(params[:per_page] || 20)

    # Renders the list of connected apps 'me/applications'
    render :applications
  end

  def disconnect
    id = require_params!(:id)
    connection = @user.connected_applications.find_by(application_id: id)

    raise ParamsError.new(I18n.t("errors.applications.not_found", id: id)) unless connection

    connection.update(status: "disconnected") if connection.connected?

    @connected_apps = @user.connected_applications.page(params[:page]).per(params[:per_page] || 20)

    # Renders the list of connected apps 'me/applications'
    render :applications
  end

  def reset_app_password 
    app_id, email = require_params!(:appId, :email)

    application = Application.find(app_id)
    
    # Only does the reset password if the application is configured to do so
    # That means that the app is password authenticated 
    if application.config["auth"]["needs_password"]
      Api::PasswordResetter.new(email, application).reset!
    end

    render json: { success: true }, status: 200
  end

  def update_settings 
    @user.settings.update(params.permit(:notifications_active))
  end
end
