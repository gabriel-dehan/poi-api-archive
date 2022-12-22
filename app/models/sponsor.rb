class Sponsor < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :company
end
