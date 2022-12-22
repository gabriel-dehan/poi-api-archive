class Notifier 
  ALLOWED_TYPES = ["generic", "level_reached", "challenge_received", "daily_digest"]

  attr_reader :user 

  def initialize(user)
    @user = user 
  end

  def notify!(attributes)
    type = attributes[:type]
    title = attributes[:title]
    content = attributes[:content]
    payload = attributes[:payload]
    segments = attributes[:segments]

    raise ArgumentError.new("Wrong notification type: #{type}") unless ALLOWED_TYPES.include? type 

    headings = OneSignal::Notification::Headings.new(en: title)
    contents = OneSignal::Notification::Contents.new(en: content)

    uses_segments = segments && segments.any?

    if uses_segments
      attachments = OneSignal::Attachments.new({
        data: {
          notification_type: type, 
          payload: payload.is_a?(String) ? payload : JSON.dump(payload) # stringify if not already stringified
        }
      })
      
      notification = OneSignal::Notification.new({ 
        headings: headings, 
        contents: contents, 
        attachments: attachments,
        included_segments: segments
      })
    else 
      attachments = OneSignal::Attachments.new({
        data: {
          notification_type: type, 
          user_id: user.id, 
          payload: payload.is_a?(String) ? payload : JSON.dump(payload) # stringify if not already stringified
        }
      })

      query = OneSignal::Filter.tag('userId') == user.id

      notification = OneSignal::Notification.new({ 
        headings: headings, 
        contents: contents, 
        attachments: attachments,
        filters: [query]
      })
    end

    begin
      unless ThreadedConfig.is_silent?
        if user.settings.notifications_active || uses_segments
          
          OneSignal.send_notification(notification)

          Analytics.track({
            user_id: user.id,
            event: 'Notification Sent',
            properties: { 
              type: type,
              title: title        
            }
          })
        end
      end

    rescue OneSignal::Client::ApiError => e  
      puts "OneSignal::Client::ApiError: #{e.message}"
    end
  end

  # user = nil, segment
  def notify_new_app(application)
    icon = application.icon 
    app_name = application.name 

    notify!({
      segments: [OneSignal::Segment::ACTIVE_USERS],
      type: "generic",
      title: I18n.t("notifications.new_app.title", app: app_name),
      content: I18n.t("notifications.new_app.content", app: app_name),
      payload: {
        title: I18n.t("notifications.new_app.modal_title", app: app_name),
        message: I18n.t("notifications.new_app.modal_content", app: app_name),
        icon: icon,
        buttonLabel: I18n.t("notifications.new_app.button"),
        redirection: nil
      }
    })
  end

  # user = impact.user
  # Provide the category (mobility, et)
  def notify_level_reached(impactable)
    # We don't want to notify too often if someone passes multiple levels at the same time
    can_notify = user.last_level_up_notified_at ? (user.last_level_up_notified_at + 5.minutes) <= DateTime.now : true 

    if can_notify
      level = impactable.level 
      status_uid = user.impact.get_status_uid
      level_count_until_next_status = user.impact.get_levels_until_next_status
      category = impactable.try(:category)

      if category # if this is a category level up
        raise ArgumentError.new("Category does not exist") unless Application::Categories.include?(category)

        challenge_category = category
        title = I18n.t("notifications.level_reached_category.title", level: level, category: I18n.t("categories.#{category}.title"))
      else # if this is a global level up
        # We take the category where the user has the most points
        challenge_category = user.categorized_impacts.order(earned_points_cents: :desc).limit(1).first.category
        title = I18n.t("notifications.level_reached.title", level: level)
      end

      # Note: this data structure is also used in user.rb/launchable_challenges
      notify!({
        type: "level_reached",
        title: title,
        content: I18n.t("notifications.level_reached.content", level: level),
        payload: {
          goals: FriendsChallenge::GOALS,
          rewards: FriendsChallenge::POSSIBLE_REWARDS,
          status_uid: status_uid,
          level_reached: level, 
          level_count_until_next_status: level_count_until_next_status,
          category: category ? category : nil,
          category_label: category ? I18n.t("categories.#{category}.title") : nil,
          challenge_category: challenge_category,
          challenge_category_label: I18n.t("categories.#{challenge_category}.title"),
          actions_examples: Event.examples(category)
        }
      })

      user.update(last_level_up_notified_at: DateTime.now)
    end
  end

  # user = challenge.challenged
  def notify_challenge_received(challenge)
    payload = ApplicationController.new.view_context.render 'v1/challenges/show', challenge: challenge, current_user: challenge.challenged
    challenger = challenge.challenger.name

    notify!({
      type: "challenge_received",
      title: I18n.t("notifications.challenge_received.title", challenger: challenger),
      content: I18n.t("notifications.challenge_received.content", challenger: challenger),
      payload: payload
    })
  end
  
  # user = challenge.challenger
  def notify_challenge_accepted(challenge)
    challenged = challenge.challenged.name

    notify!({
      type: "generic",
      title: I18n.t("notifications.challenge_accepted.title", challenged: challenged),
      content: I18n.t("notifications.challenge_accepted.content", challenged: challenged),
      payload: {
        title: I18n.t("notifications.challenge_accepted.modal_title", challenged: challenged),
        message: I18n.t("notifications.challenge_accepted.modal_content", challenged: challenged, reward: challenge.reward),
        avatar_status_uid: challenge.challenged.impact.get_status_uid,
        buttonLabel: I18n.t("notifications.challenge_accepted.button"),
        redirection: nil
      }
    })
  end

  # user = challenge.challenger
  def notify_challenge_completed(challenge)
    challenged = challenge.challenged.name

    notify!({
      type: "generic",
      title: I18n.t("notifications.challenge_completed.title", challenged: challenged),
      content: I18n.t("notifications.challenge_completed.content", challenged: challenged),
      payload: {
        title: I18n.t("notifications.challenge_completed.modal_title", challenged: challenged),
        message: I18n.t("notifications.challenge_completed.modal_content", challenged: challenged, reward: challenge.reward),
        avatar_status_uid: challenge.challenged.impact.get_status_uid,
        buttonLabel: I18n.t("notifications.challenge_completed.button"),
        redirection: nil
      }
    })
  end

  def notify_referral(referred_user)
    referee = referred_user.name 

    notify!({
      type: "generic",
      title: I18n.t("notifications.referee_signed_up.title", referee: referee),
      content: I18n.t("notifications.referee_signed_up.content", referee: referee),
      payload: {
        title: I18n.t("notifications.referee_signed_up.modal_title", referee: referee),
        message: I18n.t("notifications.referee_signed_up.modal_content", referee: referee, reward: Task::Invite.get.reward),
        avatar_status_uid: user.impact.get_status_uid,
        buttonLabel: I18n.t("notifications.referee_signed_up.button"),
        redirection: nil
      }
    })
  end

  def send_announcement(type)
    segments = [OneSignal::Segment::ACTIVE_USERS]
    # TODO
  end

  def send_daily_digest
    actions = user.events.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    earned_today = (actions.map(&:impact_points_cents).sum / 100.0).floor

    # Only send a daily digest if something happened today
    # Maybe send something else if nothing happened
    if actions.any? 
      notify!({
        # segments: [OneSignal::Segment::ACTIVE_USERS], # TODO: Incorrect
        type: "daily_digest",
        title: I18n.t("notifications.daily_digest.title", earned_today: earned_today),
        content: I18n.t("notifications.daily_digest.content", earned_today: earned_today),
        payload: {
          title: I18n.t("notifications.daily_digest.modal_title", earned_today: earned_today),
          message: I18n.t("notifications.daily_digest.modal_content", earned_today: earned_today),
          buttonLabel: I18n.t("notifications.daily_digest.button"),
          daily_digest: {
            actions_by_category: actions.group_by { |e| e.category }.map { |cat, events| [cat, { label: I18n.t("categories.#{cat}.title"), amount: (events.map(&:impact_points_cents).sum / 100.0).floor }] }.to_h
          }
        }
      })
    end
  end

  def send_task_window
    html = ApplicationController.new.view_context.render 'v1/notifications/tasks', test: true

    notify!({
      type: "generic",
      title: "BRAVO 🎉 Tu peux commencer à mesurer ton impact !",
      content: "Test",
      payload: {
        title: "BRAVO 🎉 Tu peux commencer à mesurer ton impact !",
        innerHtmlMessage: html,
        buttonLabel: "Ok super !",
      }
    })
  end
end