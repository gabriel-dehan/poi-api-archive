class Criterium < ApplicationRecord
  has_many :sub_criteria, dependent: :destroy
  has_many :sub_criterium_fulfillments, through: :sub_criteria

  validates :name, presence: true
  validates :uid, presence: :true
  validates :category, presence: true, inclusion: { in: Application::Categories }
end