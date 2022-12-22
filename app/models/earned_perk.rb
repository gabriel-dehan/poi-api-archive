class EarnedPerk < ApplicationRecord
  belongs_to :user
  belongs_to :perk

  before_create :create_use_code 
  before_create :setup_expiration_date

  # After create, compute balances change
  after_create :update_balances

  scope :used, -> { where(status: ["used", "expired"]) }
  scope :active, -> { where(status: "active") }
  scope :expired, -> { where(status: "expired") }

  private 
  def create_use_code 
    code = nil
    loop do
      code = SecureRandom.hex[0, 6].upcase
      break code unless EarnedPerk.where(use_code: code).first
    end
    self.use_code = code
  end 

  def setup_expiration_date
    number, timespan = perk.lifespan.split
    self.expires_at = Date.today + number.to_i.send(timespan) 
  end

  def update_balances
    user.impact.current_points_cents -= perk.price_cents
    user.impact.spent_points_cents += perk.price_cents
    user.impact.save
  end
end