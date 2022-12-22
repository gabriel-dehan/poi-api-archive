class Company < ApplicationRecord
  paginates_per 20
  max_paginates_per 20

  # Actually sponsored
  has_many :sponsors
end
