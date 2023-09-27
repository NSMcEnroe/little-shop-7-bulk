class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  enum :status, ["pending", "packaged", "shipped"]

  def self.merchant_specific(merchant)
    where(item: merchant.items)
  end

  def discount
    invoice_item_discount = item.merchant.merchant_bulk_discounts
    .where("merchant_bulk_discounts.min_quality <= ?", quantity)
    .order(percentage: :desc)
    .first
  end
end
