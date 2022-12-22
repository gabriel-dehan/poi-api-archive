class Funding < ApplicationRecord
  paginates_per 20
  max_paginates_per 20

  belongs_to :user
  belongs_to :campaign 
  
  # After create, compute balances change
  after_create :update_balances

  validates :amount_cents, presence: true, numericality: { only_integer: true }

  scope :active, -> { joins(:campaign).where('campaigns.status = ?', 'active') }
  scope :funded, -> { joins(:campaign).where('campaigns.status = ?', 'funded') }  

  def amount 
    amount_cents / 100.0
  end

  def update_balances
    campaign.total_funded_cents += amount_cents
    campaign.save
    user.impact.current_points_cents -= amount_cents
    user.impact.spent_points_cents += amount_cents
    user.impact.save
  end

end