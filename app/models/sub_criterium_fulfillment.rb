class SubCriteriumFulfillment < ApplicationRecord
  belongs_to :resource, polymorphic: true # application or merchant
  belongs_to :sub_criterium
end