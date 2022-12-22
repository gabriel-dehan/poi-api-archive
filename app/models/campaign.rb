class Campaign < ApplicationRecord
  paginates_per 20
  max_paginates_per 20

  has_many :fundings
  has_many :pictures, as: :resource

  validates :name, presence: true
  # Amount in points as integer
  # validates :goal_cents, presence: true, numericality: { only_integer: true }
  validates :total_funded_cents, numericality: { only_integer: true }

  def self.spotlight
    Campaign.all.take(3)
  end

  def banner
    self.pictures.find_by(type: "banner")&.file&.url || "https://s3.somewhere.over/the-rainbow/seeds/banner_default.png"
  end

  def icon
    self.pictures.find_by(type: "icon")&.file&.url || "https://s3.somewhere.over/the-rainbow/seeds/logo_default.png"
  end

  def goal
    goal_cents / 100.0
  end

  def total_funded
    total_funded_cents / 100.0
  end
end