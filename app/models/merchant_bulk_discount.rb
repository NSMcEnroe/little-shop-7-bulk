class MerchantBulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :percentage, presence: true
  validates :min_quality, presence: true

end
