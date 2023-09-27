require "rails_helper"

RSpec.describe "Merchant Bulk Discounts update page" do
  it "displays a form that is pre-populated and changes when hitting submit" do
    @merchant_1 = create(:merchant)
  
    @bulk_discount_1 = create(:merchant_bulk_discount, merchant_id: @merchant_1.id)
  
    visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}"
  
    click_link("Edit Bulk Discount")
  
    fill_in("merchant_bulk_discount[percentage]", with: 12)
    fill_in("merchant_bulk_discount[min_quality]", with: 13)
  
    click_button("Edit Bulk Discount")

    expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant_1))

    expect(page).to have_content(12) 
    expect(page).to have_content(13) 
  end
end