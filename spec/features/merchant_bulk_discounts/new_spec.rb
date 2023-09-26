require "rails_helper"

RSpec.describe "Merchant Bulk Discounts new page" do
  it "user can fill in a form to add a new discount" do
    @merchant_1 = create(:merchant)
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)

    @item_1 = create(:item, merchant_id: @merchant_1.id)
    @item_2 = create(:item, merchant_id: @merchant_1.id)
    @item_3 = create(:item, merchant_id: @merchant_1.id)
    @item_4 = create(:item, merchant_id: @merchant_1.id)
    @item_5 = create(:item, merchant_id: @merchant_1.id)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id, created_at: "2012-03-25 09:54:09 UTC")
    @invoice_2 = create(:invoice, customer_id: @customer_2.id, created_at: "2012-03-26 09:54:09 UTC")
    @invoice_3 = create(:invoice, customer_id: @customer_3.id, created_at: "2012-03-27 09:54:09 UTC")
    @invoice_4 = create(:invoice, customer_id: @customer_4.id, created_at: "2012-03-28 09:54:09 UTC")
    @invoice_5 = create(:invoice, customer_id: @customer_5.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, status: 1)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, status: 1)
    @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, status: 1)
    @invoice_item_4 = create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_4.id, status: 1)
    @invoice_item_5 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_5.id, status: 1)

    @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: 1)
    @transaction_2 = create(:transaction, invoice_id: @invoice_2.id, result: 1)
    @transaction_3 = create(:transaction, invoice_id: @invoice_3.id, result: 1)
    @transaction_4 = create(:transaction, invoice_id: @invoice_4.id, result: 1)
    @transaction_5 = create(:transaction, invoice_id: @invoice_5.id, result: 1)

    visit "/merchants/#{@merchant_1.id}/bulk_discounts"

    expect(page).to have_field("percentage")
    expect(page).to have_field("min_quality")
    expect(page).to have_button("Submit")

    fill_in "percentage", with: 10
    fill_in "min_quality", with: 15

    click_button("Submit")
    expect(page).to have_current_pa


