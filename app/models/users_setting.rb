class UsersSetting < ApplicationRecord
  has_one :user

  validates :notifications_active, presence: true, inclusion: [true, false]

  def as_json(options={})
    super(options.merge({ except: [:id, :created_at] }))
  end
end