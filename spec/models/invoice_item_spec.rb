require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
  end

  describe "#merchant_specific" do
    it "returns items only appropriate to the correct merchant" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @customer_1 = create(:customer)

      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_2.id)
      @item_3 = create(:item, merchant_id: @merchant_1.id)

      @invoice_1 = create(:invoice, customer_id: @customer_1.id)

      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 2)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_1.id)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id)

      expect(@invoice_1.invoice_items.merchant_specific(@merchant_1)).to eq([@invoice_item_1, @invoice_item_3])
    end
  end
  describe "#discount" do
    it "returns the best discount from ther merchant bulk discounts list" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @customer_1 = create(:customer)
    
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_2.id)
      @item_3 = create(:item, merchant_id: @merchant_1.id)
    
      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
  
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 25, unit_price: 1000, status: 1)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_1.id, unit_price: 2000, status: 1)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id, unit_price: 3000, status: 1)

      @bulk_discount_1 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id, percentage: 10, min_quality: 15)
      @bulk_discount_2 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id, percentage: 15, min_quality: 20)
      @bulk_discount_3= create(:merchant_bulk_discount, merchant_id: @merchant_1.id, percentage: 20, min_quality: 30)
      @bulk_discount_3= create(:merchant_bulk_discount, merchant_id: @merchant_2.id, percentage: 25, min_quality: 10)


      expect(@invoice_item_1.discount).to eq(@bulk_discount_2)
    end
  end
end
