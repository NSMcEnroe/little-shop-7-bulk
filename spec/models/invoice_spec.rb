require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
  end

  describe "validations" do
    it { should validate_presence_of(:status) }
  end

  describe "#not_fulfilled" do
    it "can return all invoices that are not fulfilled" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, status: 0)
      invoice_2 = create(:invoice, customer: customer_1, status: 1)

      @invoices = Invoice.all

      expect(@invoices.not_fulfilled).to eq([invoice_1])
    end

    it "organizes the invoices from oldes to newest" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, status: 0, created_at: DateTime.now)
      invoice_2 = create(:invoice, customer: customer_1, status: 0)

      @invoices = Invoice.all

      expect(@invoices.not_fulfilled).to eq([invoice_2, invoice_1])
    end
  end

  describe "#total_revenue" do
    it "can return the total revenue for an invoice" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1, unit_price: 1000)
      item_2 = create(:item, merchant: merchant_1, unit_price: 2000)

      invoice_1 = create(:invoice, customer: customer_1)
      invoice_2 = create(:invoice, customer: customer_1)

      invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 1, unit_price: 1000)
      invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 2, unit_price: 2000)

      transaction_1 = create(:transaction, invoice: invoice_1)
      transaction_2 = create(:transaction, invoice: invoice_2)

      invoices = Invoice.all

      total_revenue = invoices.sum(&:total_revenue)

      expect(total_revenue).to eq(5000)
    end
  end

  describe "#specific_revenue" do 
    it "can return the specific revenue for a merchant" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1, unit_price: 1000)
      item_2 = create(:item, merchant: merchant_2, unit_price: 2000)

      invoice_1 = create(:invoice, customer: customer_1)


      invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 1, unit_price: 1000)
      invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_1, quantity: 2, unit_price: 2000)

      transaction_1 = create(:transaction, invoice: invoice_1)
      transaction_2 = create(:transaction, invoice: invoice_1)

      

      expect(invoice_1.specific_revenue(merchant_1)).to eq(1000)
    end
  end

  describe "#discount_revenue" do
    it "returns the discounted revenue on an invoice for a particular merchant" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @customer_1 = create(:customer)
    
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_2.id)
      @item_3 = create(:item, merchant_id: @merchant_1.id)
    
      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
  
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 25, unit_price: 100, status: 1)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_1.id, unit_price: 2000, status: 1)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id, unit_price: 3000, status: 1)

      @bulk_discount_1 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id, percentage: 10, min_quality: 15)

      expect(@invoice_1.discount_revenue(@merchant_1)).to eq(5250)
    end
  end

  describe "#unique_merchants" do
    it "returns all unique merchants in an invoice" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @customer_1 = create(:customer)
      @merchant_3 = create(:merchant)
    
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_2.id)
      @item_3 = create(:item, merchant_id: @merchant_1.id)
    
      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
  
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 25, unit_price: 100, status: 1)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_1.id, unit_price: 2000, status: 1)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id, unit_price: 3000, status: 1)

      @bulk_discount_1 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id, percentage: 10, min_quality: 15)

      expect(@invoice_1.unique_merchants).to eq([@merchant_1.id, @merchant_2.id])
    end
  end

  describe "#discounted_invoice_revenue" do
    it "returns the total discounted revenue for the entire invoice" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @customer_1 = create(:customer)
      
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_2.id)
      @item_3 = create(:item, merchant_id: @merchant_1.id)
      @item_4 = create(:item, merchant_id: @merchant_1.id)
      
      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 25, unit_price: 1000, status: 1)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_1.id, unit_price: 2000, status: 1)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: 3000, status: 1)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id, unit_price: 3000, status: 1)
  
      @bulk_discount_1 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id, percentage: 20, min_quality: 20)
      @bulk_discount_1 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id, percentage: 10, min_quality: 10)

      expect(@invoice_1.discounted_invoice_revenue).to eq(52000)
    end
  end
end
