class KnownContact < ApplicationRecord
  # The user that holds the repertoir of contacts
  belongs_to :user
  # On of the contacts in the user's repertoir
  belongs_to :contact, class_name: "User"
end
