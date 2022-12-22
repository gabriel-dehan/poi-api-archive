class Activation < ApplicationRecord
  belongs_to :sub_criterium
  belongs_to :event, optional: true # because we need to be able to create it first

  # Belongs to through
  #delegate :sub_criterium, :to => :sub_criterium_fulfillment

  validates :impact_points_cents, presence: true 

  def impact_points 
    impact_points_cents / 100.0
  end

end