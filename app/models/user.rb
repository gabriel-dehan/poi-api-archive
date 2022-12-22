# frozen_string_literal: true

class User < ActiveRecord::Base
  paginates_per 20
  max_paginates_per 20
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  include DeviseTokenAuth::Concerns::User
  include UsersTasks

  before_create :setup_impact
  before_create :setup_settings
  after_create :generate_referral
  after_create :has_been_invited_or_referred?
  after_create :has_challenges_waiting?
  after_create :segment_identify_user
  after_create :onboarding_completed

  has_many :sponsors, as: :resource

  has_many :friendships, dependent: :destroy
  has_many :friends, -> { ranked }, through: :friendships, foreign_key: "friend_id", class_name: "User"
  
  has_many :known_contacts, dependent: :destroy
  has_many :suggested_friends, through: :known_contacts, source: :contact

  has_many :invitees, class_name: "Invite", foreign_key: "inviter_id", dependent: :destroy
  has_one :invitation, class_name: "Invite", foreign_key: "invitee_id"

  has_many :connected_applications, dependent: :destroy
  has_many :applications, through: :connected_applications

  has_many :earned_perks, dependent: :destroy
  has_many :perks, through: :earned_perks

  has_many :applications_votes, dependent: :destroy
  has_many :potential_applications, through: :applications_votes

  has_many :given_friends_challenges, foreign_key: :challenger_id, class_name: "FriendsChallenge", dependent: :destroy
  has_many :received_friends_challenges, foreign_key: :challenged_id, class_name: "FriendsChallenge", dependent: :destroy

  # Funded campaigns
  has_many :fundings, dependent: :destroy
  has_many :campaigns, through: :fundings

  belongs_to :referrer, class_name: "User", optional: true

  belongs_to :impact, optional: true
  delegate :categorized_impacts, to: :impact
  # TODO: Replace with has_many :events, actually don't need that
  # But we might need to also handle the order and stuff like that for the history
  delegate :events, to: :impact

  belongs_to :users_setting, optional: true
  alias_attribute :settings, :users_setting

  # TODO (L): Handle differente countries
  phony_normalize :phone_number, default_country_code: 'FR'

  validates :full_name, presence: true
  validates :phone_number, uniqueness: true

  scope :ranked, -> { joins(:impact).order("impacts.earned_points_cents DESC") }
  scope :ranked_reverse, -> { joins(:impact).order("impacts.earned_points_cents DESC") }

  def name
    full_name
  end

  # TODO should probably not be computed everytime
  def rank 
    @rank ||= (self.class.ranked_reverse.index { |u| u.id == self.id } + 1)
    ActionController::Base.helpers.number_to_human(@rank,format:'%n%u', units: { thousand: 'K', million:'M', billion:'B' })
  end

  def has_wished_for(potential_application)
    @wishes ||= self.applications_votes.pluck(:potential_application_id)
    @wishes.include?(potential_application.id)
  end

  # Returns true if a user can challenge in any category (he just leveled up)
  def can_challenge
    categories_impact_can_challenge = self.impact.categorized_impacts
      .reject { |ci| ci.category == "bonus" }
      .map { |ci| ci.current_cycle.can_challenge }
    categories_impact_can_challenge << self.impact.current_cycle.can_challenge 

    categories_impact_can_challenge.select { |able| able == true }.any?
  end

  # Returns an array of launchable challenges. The same data structure is used for level_reached notifications
  def launchable_challenges
    categories_impact = self.impact.categorized_impacts
    main_impact = self.impact

    impactables = categories_impact.select { |impactable| impactable.current_cycle.can_challenge? && impactable.category != "bonus" }
    impactables << main_impact if main_impact.current_cycle.can_challenge 

    impactables.map do |impactable| 
      category = impactable.try(:category)

      if category   
        challenge_category = category
      else 
        challenge_category = self.categorized_impacts.order(earned_points_cents: :desc).limit(1).first.category
      end

      {
        goals: FriendsChallenge::GOALS,
        rewards: FriendsChallenge::POSSIBLE_REWARDS,
        status_uid: main_impact.get_status_uid,
        level_reached: impactable.level, 
        level_count_until_next_status: main_impact.get_levels_until_next_status,
        category: category ? category : nil,
        category_label: category ? I18n.t("categories.#{category}.title") : nil,
        challenge_category: challenge_category,
        challenge_category_label: I18n.t("categories.#{challenge_category}.title"),
        actions_examples: Event.examples(category)
      }
    end
  end

  # Returns the latest challenge a user can "launch" (send to a friend if he has not done it already)
  def launchable_challenge
    launchable_challenges.first
  end

  def friends_suggestions
    suggested_friends.where.not(id: friends.pluck(:id)).where.not(id: self.id)
  end

  def connected_emails
    connected_apps.pluck(:email)
  end
  
  def unconnected_apps 
    Application.all.where.not(id: self.applications.pluck(:id))
  end

  def befriend(friend)
    raise ArgumentError.new(I18n.t("errors.users.friends.befriend_self")) if friend == self
    self.friendships.find_or_create_by!(friend: friend)
  end

  def unfriend(friend)
    self.friendships.find_by(friend: friend).destroy
  end
  
  # Unstable way of doing this, fix it
  # def ensure_internal_auth_token(force = false)
  #   _headers = {}

  #   if force 
  #     _headers = self.create_new_auth_token("poi-internal") 
  #   elsif tokens["poi-internal"]
  #     token_is_valid = DateTime.now < Time.at(tokens["poi-internal"]["expiry"]).to_datetime
  #     _headers = self.create_new_auth_token("poi-internal") unless token_is_valid
  #   else 
  #     _headers = self.create_new_auth_token("poi-internal") 
  #   end

  #   @_refreshed_internal_token = _headers['access-token']
  # end

  # Should only be used for private routes, never to be sent to the client
  def as_json(options={})
    # Makes sure internal apis never have expired tokens
    if @_refreshed_internal_token
      super(options).merge(internal_token: @_refreshed_internal_token, connected_applications: self.connected_applications, settings: self.users_setting)
    else
      super(options).merge(connected_applications: self.connected_applications, settings: self.users_setting)
    end
  end

  private 
  # This one is a bit weird I am sorry, but a bit short timing-wise so:
  # `referrer_code` in the DB means the referral code provided upon sign up (the referral this account is using)
  # `referral code` is the referral code you provide to other users when they wanna sign up (the referral this account is providing)
  # referrer_code should be named "used_referral_code" or something
  def has_been_invited_or_referred?
    # referrer
    ref = nil 

    # If no referral code was provided during sign up
    if referrer_code.blank?
      # Look for an invite
      invite = Invite.find_by(status: "pending", phone_number: phone_number)
      if invite 
        # Update the invite
        invite.update(invitee: self, status: "accepted")
        # Use the inviter as a referrer
        ref = invite.inviter
        self.referrer_code = ref.referral_code
      end
    else
      # If a referral was provided during sign up
      ref = User.find_by(referral_code: referrer_code)
      unless ref
        raise ArgumentError.new(I18n.t("errors.registration.wrong_referral_code"))
      end
    end

    if ref 
      self.referrer = ref
      self.save!
     
      # Trigger referrer reward for the Task
      ref.action_taken!(Task::Invite)

      # Trigger referree reward (not through a Task though)
      Event.emit(
        type: "referral:referree",
        user: self
      )

      # Adds the referrer to the suggested friends (in case he gets unfriended)
      self.known_contacts.find_or_create_by(contact: ref)
      # Automaticaly befriend the referrer
      self.befriend(ref)
      
      Notifier.new(ref).notify_referral(self)

      Analytics.track({
        user_id: self.id,
        event: 'Contact Referred',
        properties: { 
          referrerEmail: ref.email,
          referreeEmail: self.email
        }
      })
    end
  end

  def onboarding_completed
    Event.emit(
      type: "onboarding:done",
      user: self
    )
  end

  # If the user has waiting challenges upon sign up
  def has_challenges_waiting?
    waiting_challenges = FriendsChallenge.where(challenged_phone_number: phone_number, status: "pending", challenged_id: nil)
    waiting_challenges.update_all(challenged_id: self.id) if waiting_challenges.any?
  end


  def generate_referral
    referral = nil
    loop do
      referral = SecureRandom.hex[0, 6].upcase
      break referral unless User.where(referral_code: referral).first
    end
    self.referral_code = referral
    self.save
  end

  def setup_impact
    if valid? && !impact
      self.impact = Impact.create!
      self.impact.gauge_cycles.create!
      self.impact.create_categorized_impacts!
    end
  end

  def setup_settings
    if valid? && !settings
      self.users_setting = UsersSetting.create!
    end
  end

  def segment_identify_user
    Analytics.identify({
      user_id: self.id,
      traits: {
        name: self.full_name,
        email: self.email,
        created_at: DateTime.now
      }
    })

    Analytics.track({
      user_id: self.id,
      event: 'Account Created',
      #properties: { plan: 'Enterprise' }
    })
  end
end
