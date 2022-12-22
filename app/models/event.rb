class Event < ApplicationRecord
  self.inheritance_column = 'sti_type'

  # TODO: Also used for display in app, not very clean (cf: challenge)
  StaticImpacts = {
    'referral:referree' => 10,
    'challenge' => 10,
    'onboarding:done' => 5,
    'onboarding:application' => 5,
    'application:connected' => 5,
  }

  # Everything that is not an `action` goes into the `Bonus` category
  Types = [
    'referral:referree',
    'referral:referrer', # needed for legacy events
    'challenge',
    'onboarding:done',
    'onboarding:application',
    'application:connected',
    'task',
    'action'
  ]

  EventTypeError = Class.new(StandardError)
  EmissionOverflow = Class.new(StandardError)

  after_create :process_impact_change
  after_create :update_challenge
  #after_create :trigger_notifications
  after_create :segment_track_events

  has_many :activations, dependent: :destroy

  belongs_to :user
  belongs_to :application, optional: true

  def self.defined?(event_type)
    Event::Types.include? event_type
  end

  def title
    if type == "action"
      if application_id
        tkey =  "events.#{type}.applications.#{application.uid}"
        if I18n.exists?(tkey)
          I18n.t(tkey)
        end
      end
      I18n.t("events.#{type}.categories.#{application.category}")
    elsif type == "task"
      I18n.t("events.#{type}.#{task_type}")
    else
      I18n.t("events.#{type}")
    end
  end

  def icon
    application&.icon || "https://s3.somewhere.over/the-rainbow/application/icon/logo-bg.png"
  end

  def impact_points
    impact_points_cents / 100.0
  end
  alias_method :earned_points, :impact_points
  alias_attribute :earned_points_cents, :impact_points_cents

  def self.emit(attr)
    type = attr[:type]
    raise EventTypeError.new("`#{type}` is not a valid event type.") unless Event.defined? type
    if type == 'action'
      app = Application.find_by(id: attr[:application_id])
      event = self.new(
        type: attr[:type],
        user: attr[:user],
        application: app,
        category: attr[:category],
        parameters: attr[:data],
        datetime: Time.now
      )
    else # Tasks & static events
      event = self.new(
        type: attr[:type],
        user: attr[:user],
        category: "bonus",
        parameters: attr[:data] || {},
        datetime: Time.now
      )
    end

    raise EmissionOverflow.new("Can't emit event/#{event.type}, over the tolerated emitions limit.") unless event.emitable?

    # Computes the impact score and creates the necessary criteria activations attached to the event
    event = Network::Impact.assess(event)

    event.save!
    event
  end

  # TODO (L): Implement limits per event type
  def emitable?
    true
  end

  def task_type
    if type == "task"
      # Task::BugReport -> bug_report
      parameters["task"] && parameters["task"].underscore.gsub('task/', '')
    end
  end

  # Returns actions examples, for now it's using the locale's yaml as a source
  def self.examples(category = nil)
    # If category is bonus treat it as if no category
    category = category == "bonus" ? nil : category

    # If no category, take a selected sample of categories
    categories = category ? [category] : [:mobility, :consumption, :recycling]

    categories.map do |category|
      I18n.t("categories.#{category}.examples")
      I18n.t("categories.#{category}.examples").map do |example|
        { icon: Application.find_by(uid: example[:icon]).icon, title: example[:title], reward: example[:reward ]}
      end
    end.flatten.shuffle.take(3)
  end

  def as_json(options={})
    super(options).merge(title: title)
  end

  private
  def update_challenge
    user.received_friends_challenges.where(category: category, status: "accepted").each do |challenge|
      new_score = challenge.score_cents + earned_points_cents
      if new_score >= challenge.goal
        # Make sure we can't have a score greater than the goal and update status
        challenge.update(score_cents: challenge.goal, status: "completed")
      else
        challenge.update(score_cents: new_score)
      end

    end
  end

  # After an event is created and impact is assessed,
  # we need to add the impact to the gauges
  def process_impact_change
    # Update categorized gauge
    self.user.impact.categorized_gauge(self.category).register_event(self)
    # Updates main gauge
    self.user.impact.current_cycle.register_event(self)
  end

  def segment_track_events
    Analytics.track({
      user_id: self.user_id,
      event: 'New Event',
      properties: {
        name: self.title,
        type: self.type,
        category: self.category,
        amount: self.earned_points
      }
    })
  end

  # def trigger_notifications
  #   if type == Event::Type::Transaction
  #     transaction = self.emitter
  #     merchant = transaction.receiver.merchant
  #     ecosystem = merchant.ecosystem
  #     user = self.subject
  #     currency_with_amount = Currency.new(
  #       currency: :eur,
  #       amount: transaction.amount,
  #     )

  #     tx_amount = transaction.amount / 100.0

  #     reward = Currency.new(
  #       currency: ecosystem.reward_currency,
  #       amount: self.total_impact * Poi::Network::EURO_POINT_VALUE.to_f,
  #       to_cents: true
  #     ).to_decimal

  #     funding = (tx_amount * Funding::Fee)

  #     headings = OneSignal::Notification::Headings.new(en: 'Vous avez reçu un paiement !',)
  #     contents = OneSignal::Notification::Contents.new(en: "#{user.name}: #{currency_with_amount.to_decimal}#{currency_with_amount.symbol}")
  #     query = OneSignal::Filter.tag('userId') == merchant.uid
  #     attachments = OneSignal::Attachments.new({
  #       data:            { transaction_id: transaction.id },
  #       url:             "#{ENV['MERCHANT_APP_URL']}/transaction?date=#{transaction.datetime}&name=#{user.name}&amount=#{tx_amount - reward}&reward=#{reward}&funding=#{funding}"
  #     })

  #     notification = OneSignal::Notification.new({
  #       headings: headings,
  #       contents: contents,
  #       attachments: attachments,
  #       filters: [query]
  #     })
  #     OneSignal.send_notification(notification)
  #   end
  # end

end