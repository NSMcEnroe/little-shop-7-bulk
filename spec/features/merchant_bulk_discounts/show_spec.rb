require "rails_helper"

RSpec.describe "Merchant bulk discounts show page" do
  it "displays the bulk discount quantity threshold and percentage discount" do
    @merchant_1 = create(:merchant)

    @bulk_discount_1 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id)
    @bulk_discount_2 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id)

    visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_2.id}"

    expect(page).to have_content("Quantity Threshold: #{@bulk_discount_2.min_quality}")
    expect(page).to have_content("Percentage Discount: #{@bulk_discount_2.percentage}")
  end

  it "displays a link to edit each bulk discount" do
    @merchant_1 = create(:merchant)

    @bulk_discount_1 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id)

    visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}"

    expect(page).to have_content("Edit Bulk Discount")

    click_link("Edit Bulk Discount")

    expect(page).to have_link("Edit Bulk Discount", href: "/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}/edit")
  end

end