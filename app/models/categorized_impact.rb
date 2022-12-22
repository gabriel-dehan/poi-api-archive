class CategorizedImpact < ApplicationRecord
  include CategorizedImpactProgression

  belongs_to :impact
  has_many :gauge_cycles, as: :impactable, dependent: :destroy

  validates :earned_points_cents, presence: true, numericality: true
  validates :category, presence: true, inclusion: { in: Application::Categories }
  validates :category, uniqueness: { scope: :impact_id }

  def earned_points 
    earned_points_cents / 100.0
  end

  def events 
    Event.where(id: gauge_cycles.pluck(:events_ids).flatten.uniq)
  end

  def current_cycle
    gauge_cycles.where(current: true).order(created_at: :desc).limit(1).first
  end
  alias_method :gauge, :current_cycle

  def level_up!
    self.increment!(:level, 1)

    Notifier.new(self.impact.user).notify_level_reached(self)

    Analytics.track({
      user_id: self.impact.user.id,
      event: 'Category Level Up',
      properties: { 
        level: self.level,
        category: self.category,
      }
    })
  end
end
