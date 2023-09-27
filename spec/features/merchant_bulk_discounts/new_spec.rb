require "rails_helper"

RSpec.describe "Merchant Bulk Discounts new page" do
  it "displays a form for a new discount" do
    merchant_1 = create(:merchant)

    visit "/merchants/#{merchant_1.id}/bulk_discounts"

    click_link("Create New Bulk Discount")

    expect(page).to have_field("merchant_bulk_discount[percentage]")
    expect(page).to have_field("merchant_bulk_discount[min_quality]")
    expect(page).to have_button("Create New Bulk Discount")
  end

  it "submits a new item and takes the user back to the merchant bulk discount index page" do
    merchant_1 = create(:merchant)

    visit "/merchants/#{merchant_1.id}/bulk_discounts/new"

    fill_in "merchant_bulk_discount[percentage]", with: 10
    fill_in "merchant_bulk_discount[min_quality]", with: 15

    click_button("Create New Bulk Discount")

    expect(page).to have_current_path(merchant_bulk_discounts_path(merchant_1))
    expect(page).to have_content(10)
    expect(page).to have_content(15)
  end
end


