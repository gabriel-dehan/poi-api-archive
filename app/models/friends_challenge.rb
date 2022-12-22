class FriendsChallenge < ApplicationRecord
  paginates_per 10
  max_paginates_per 10

  GOALS = [50]
  POSSIBLE_REWARDS = [10]

  belongs_to :challenger, class_name: "User"
  belongs_to :challenged, class_name: "User", optional: true

  before_create :compute_reward_and_end_date
  after_create :notify_challenge_received
  after_create :update_current_cycle_challenge_ability
  after_save :send_reward, if: -> { status == "completed" }
  after_save :segment_track_completed, if: -> { status == "completed" }
  after_save :notify_challenge_accepted, if: :saved_change_to_status?
  after_save :notify_challenge_completed, if: :saved_change_to_status?

  # TODO (L): Handle differente countries
  phony_normalize :challenged_phone_number, default_country_code: 'FR'

  def expired?
    self.end_date < Date.today
  end

  def score 
    score_cents / 100.0
  end

  def reward 
    reward_cents / 100.0
  end

  def compute_reward_and_end_date
    number, timespan = timeframe.split
    self.reward_cents = FriendsChallenge::GOALS.zip(FriendsChallenge::POSSIBLE_REWARDS).to_h[goal] * 100
    self.end_date = Date.today + number.to_i.send(timespan)
  end

  private 
  def send_reward
    unless rewarded 
      Event.emit(
        type: "challenge",
        user: challenger,
        data: { type: "sent_challenge", friend_challenge_id: self.id }
      )

      Event.emit(
        type: "challenge",
        user: challenged,
        data: { type: "received_challenge", friend_challenge_id: self.id }
      )

      self.update(rewarded: true)
    end
  end

  def segment_track_completed
    Analytics.track({
      user_id: self.challenged_id,
      event: 'Challenge Completed',
      properties: { 
        reward: self.reward
      }
    })
    # Analytics.track({
    #   user_id: self.challenged_id,
    #   event: 'Challenge Completed',
    #   properties: { 
    #     reward: self.reward
    #   }
    # })
  end

  def notify_challenge_received 
    if self.challenged # Only if the challenger is registered on Poi.app
      Notifier.new(self.challenged).notify_challenge_received(self)
    end
  end

  def notify_challenge_accepted 
    if saved_change_to_status.last == "accepted"
      Notifier.new(self.challenger).notify_challenge_accepted(self)
    end
  end

  def notify_challenge_completed 
    if saved_change_to_status.last == "completed"
      Notifier.new(self.challenger).notify_challenge_completed(self)
    end
  end


  def update_current_cycle_challenge_ability
    main_impact = self.challenger.impact
    category_impact = main_impact.categorized_impacts.find_by(category: category)

    main_impact_can_challenge = main_impact.current_cycle.can_challenge 
    category_impact_can_challenge = category_impact.current_cycle.can_challenge  
    
    if main_impact_can_challenge
      main_impact.current_cycle.update(can_challenge: false)
    elsif category_impact_can_challenge
      category_impact.current_cycle.update(can_challenge: false)
    else
      puts "Error: The user should not be able to create a challenge"
    end
  end
end