class Merchant < ApplicationRecord
  paginates_per 20
  max_paginates_per 20
  
  has_many :pictures, as: :resource
  has_many :merchants_qualifications
  has_many :quality_labels, through: :merchants_qualifications

  has_many :sub_criterium_fulfillments, as: :resource
  # Meh should probably be more precise according the actual fulfillment
  has_many :sub_criteria, through: :sub_criterium_fulfillments
  # Meh should probably be more precise according the actual fulfillment
  has_many :criteria, through: :sub_criteria

  # TODO (L): Handle differente countries
  phony_normalize :phone_number, default_country_code: 'FR'

  validates :name, presence: true
  validates :address, presence: true

  def fulfill_engagement(subcriterium)
    sub_criterium_fulfillments.create!(sub_criterium: subcriterium)
  end
end
