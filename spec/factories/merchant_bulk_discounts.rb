FactoryBot.define do
  factory :merchant_bulk_discount do
    association :merhcant
    percentage { [5, 10, 15, 20, 25].sample }
    min_quality { [5, 10, 15].sample }
  end
end
