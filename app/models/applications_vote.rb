class ApplicationsVote < ApplicationRecord
  belongs_to :potential_application
  belongs_to :user
end