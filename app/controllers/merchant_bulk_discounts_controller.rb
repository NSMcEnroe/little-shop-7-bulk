class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant_bulk_discount = MerchantBulkDiscount.find(params[:merchant_bulk_discount_id])
  end
end