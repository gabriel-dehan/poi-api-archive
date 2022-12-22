class MerchantsQualification < ApplicationRecord
  belongs_to :merchant
  belongs_to :quality_label
end