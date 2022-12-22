class Application < ApplicationRecord
  paginates_per 20
  max_paginates_per 20

  Categories = [
    "mobility",
    "consumption",
    "citizenship",
    "recycling",
#    "investments",
    "bonus"
  ]

  before_create :generate_api_keys
  after_create :generate_client_id

  has_many :pictures, as: :resource

  has_many :connected_applications
  has_many :users, through: :connected_applications

  has_many :perks
  has_many :events

  has_many :sub_criterium_fulfillments, as: :resource, dependent: :destroy
  has_many :sub_criteria, through: :sub_criterium_fulfillments
  has_many :criteria, -> { distinct }, through: :sub_criteria

  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true, inclusion: { in: Application::Categories }

  def banner
    self.pictures.find_by(type: "banner")&.file&.url || "https://s3.somewhere.over/the-rainbow/seeds/banner_default.png"
  end

  def icon
    self.pictures.find_by(type: "icon")&.file&.url || "https://s3.somewhere.over/the-rainbow/seeds/logo_default.png"
  end

  def self.spotlight
    Application.all.take(2)
  end

  def random_tip
    I18n.t("challenges.tips.#{category}").sample
  end

  def fulfill_engagement(subcriterium)
    sub_criterium_fulfillments.create!(sub_criterium: subcriterium)
  end

  private

  def generate_client_id
    self.api_client_id = "#{uid}_#{id}".underscore
    self.save!
  end

  def generate_api_keys
    self.api_public_key = loop do
      key = "lv_#{SecureRandom.urlsafe_base64(nil, false)}"
      break key unless self.class.exists?(api_public_key: key)
    end

    self.api_private_key = loop do
      key = "lv_#{SecureRandom.urlsafe_base64(nil, false)}"
      break key unless self.class.exists?(api_private_key: key)
    end

    self.sandbox_public_key = loop do
      key = "sb_#{SecureRandom.urlsafe_base64(nil, false)}"
      break key unless self.class.exists?(sandbox_public_key: key)
    end

    self.sandbox_private_key = loop do
      key = "sb_#{SecureRandom.urlsafe_base64(nil, false)}"
      break key unless self.class.exists?(sandbox_private_key: key)
    end
  end
end