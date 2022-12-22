class Invite < ApplicationRecord 
  paginates_per 20
  max_paginates_per 20
  
  belongs_to :invitee, class_name: "User", optional: true
  belongs_to :inviter, class_name: "User"

  # TODO (L): Handle differente countries
  phony_normalize :phone_number, default_country_code: 'FR'

  validates :phone_number, presence: true, uniqueness: { scope: :inviter,
    message: "a déjà été invité" 
  }
end