class QualityLabel < ApplicationRecord
  has_many :merchants_qualifications
  has_many :merchants, through: :merchants_qualifications

  validates :name, presence: true
end