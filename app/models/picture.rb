class Picture < ApplicationRecord
  self.inheritance_column = :kind
  
  mount_uploader :file, PictureUploader

  belongs_to :resource, polymorphic: true

  validates :type, presence: true, inclusion: { in: %w(banner photo icon), message: "%{value} is not a valid picture type" }

  def as_json(options={})
    super(options).merge(url: file.url)
  end
end