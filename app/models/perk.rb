class Perk < ApplicationRecord
  paginates_per 20
  max_paginates_per 20
  
  has_many :pictures, as: :resource
  has_one :sponsor, as: :resource

  has_many :earned_perks
  has_many :users, through: :earned_perks 

  belongs_to :application
  
  validates :name, presence: true 
  validates :price_cents, presence: true 
  validates :amount, presence: true 

  def price 
    price_cents / 100.0
  end
end