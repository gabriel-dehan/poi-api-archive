class SubCriterium < ApplicationRecord
  has_many :sub_criterium_fulfillments, dependent: :destroy
  belongs_to :criterium

  validates :name, presence: true
  validates :impact_coefficient, presence: true, numericality: true
end