class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items

  validates :status, presence: true

  enum :status, ["in progress", "completed", "cancelled"]

  def self.not_fulfilled
    where(status: 0).order(created_at: :asc)
  end

  def total_revenue
    invoice_items.sum("quantity * unit_price")
  end

  def specific_revenue(merchant)
    invoice_items.merchant_specific(merchant).sum("quantity * unit_price")
  end

  def discount_revenue(merchant)
    invoice_items.merchant_specific(merchant).sum do |invoice_item|
      if invoice_item.discount
        normal_price = (invoice_item.quantity * invoice_item.unit_price) 
        amount_off = normal_price * (invoice_item.discount.percentage / 100.0)
        discounted_price = normal_price - amount_off
        discounted_price
      else 
        (invoice_item.quantity * invoice_item.unit_price)
      end
    end
  end
end
