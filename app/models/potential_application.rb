class PotentialApplication < ApplicationRecord
  paginates_per 20
  max_paginates_per 20

  has_many :applications_votes, dependent: :destroy
  has_many :pictures, as: :resource, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def banner
    self.pictures.find_by(type: "banner")&.file&.url || "https://s3.somewhere.over/the-rainbow/seeds/banner_default.png"
  end

  def icon
    self.pictures.find_by(type: "icon")&.file&.url || "https://s3.somewhere.over/the-rainbow/seeds/logo_default.png"
  end
end