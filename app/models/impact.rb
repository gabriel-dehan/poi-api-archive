class Impact < ApplicationRecord
  include ImpactProgression

  before_save :update_current_points, if: :will_save_change_to_earned_points_cents?

  GAUGE_LEVELS = {
    0 => "baby_poi",
    3 => "young_poi",
    9 => "yogi_poi",
    16 => "master_poi",
    25 => "poi_ambassador"
  }

  has_one :user
  has_many :gauge_cycles, as: :impactable, dependent: :destroy
  has_many :categorized_impacts, dependent: :destroy

  validates :earned_points_cents, presence: true, numericality: true
  validates :spent_points_cents, presence: true, numericality: true
  validates :current_points_cents, presence: true, numericality: true

  def categorized_gauge(category)
    categorized_impacts.find_by(category: category).current_cycle
  end

  def current_cycle
    gauge_cycles.where(current: true).order(created_at: :desc).limit(1).first
  end
  alias_method :main_gauge, :current_cycle

  def events 
    Event.where(id: gauge_cycles.pluck(:events_ids).flatten.uniq)
  end

  def last_events(num)
    events.order(datetime: :desc).limit(num)
  end

  def level_up!
    self.increment!(:level, 1)

    Notifier.new(self.user).notify_level_reached(self)

    Analytics.track({
      user_id: self.user.id,
      event: 'Level Up',
      properties: { 
        level: self.level
      }
    })

    # If we reached a new ladder level
    if Impact::GAUGE_LEVELS.keys.include?(self.level)
      Analytics.track({
        user_id: self.user.id,
        event: 'Ladder Step Up',
        properties: { 
          level: self.level,
          avatar: self.get_status
        }
      })
    end
  end

  # levels_celebratory_sights = { "Baby Poi": false, etc...}
  # def has_seen_celebration(level_name)
  #   levels_celebratory_sights[level_name] || false
  # end

  def earned_points 
    earned_points_cents / 100.0
  end

  def spent_points 
    spent_points_cents / 100.0
  end

  def current_points 
    current_points_cents / 100.0
  end

  def get_status_uid
    GAUGE_LEVELS.select { |n, l| n <= level }.values.last
  end

  def get_status
    get_status_uid.humanize
  end

  def get_next_status_uid 
    Impact::GAUGE_LEVELS.select { |n, l| n > level }.values.first
  end

  def get_next_status 
    get_next_status_uid.humanize
  end

  def get_levels_until_next_status 
    Impact::GAUGE_LEVELS.select { |n, l| n > level }.keys.first - level
  end

  def total_actions_per(period)
    case period
    when "global"
      events.count
    when "month"
      events.where(datetime: Date.today.beginning_of_month..Date.today.end_of_month).count
    when "week"
      events.where(datetime: Date.today.beginning_of_week..Date.today.end_of_week).count
    end
  end

  def actions_count_per(period)
    case period
    when "global"
      events_per_month = events.group("date_trunc('month', datetime)").count.transform_keys { |k| k.month }
      result = []
      (1..12).each do |month| 
        result << (events_per_month[month] || 0)
      end
      result
    when "month"
      events_per_day = events.where(datetime: Date.today.beginning_of_month..Date.today.end_of_month).group("date_trunc('day', datetime)").count.transform_keys { |k| k.day }
      result = []
      ( Date.today.beginning_of_month.day..Date.today.end_of_month.day).each do |month| 
        result << (events_per_day[month] || 0)
      end
      result
    when "week"
      events_per_day = events.where(datetime: Date.today.beginning_of_week..Date.today.end_of_week).group("date_trunc('day', datetime)").count.transform_keys { |k| k.wday }
      result = []
      (0..6).each do |month| 
        result << (events_per_day[month] || 0)
      end
      result
    end
  end

  def create_categorized_impacts!
    Application::Categories.each do |category|
      self.categorized_impacts.find_or_create_by!(category: category) do |categorized_impact|
        categorized_impact.gauge_cycles.new
      end
    end
  end

  def update_current_points
    # Adds the newly added earned points to the current points
    pts_before, pts_after = attribute_change(:earned_points_cents)
    self.current_points_cents += pts_after - pts_before
  end

end