FactoryBot.define do
  factory :merchant_bulk_discount do
    association :merchant
    percentage { [5, 10, 15, 20, 25, 30, 35, 40, 45, 50].sample }
    min_quality { [5, 10, 15, 20, 25].sample }
  end
end
