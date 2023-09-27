class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = MerchantBulkDiscount.find(params[:merchant_bulk_discount_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = MerchantBulkDiscount.find(params[:merchant_bulk_discount_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = MerchantBulkDiscount.find(params[:merchant_bulk_discount_id])

    @merchant.update(merchant_bulk_discount_params)
    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/#{params[merchant_bulk_discount_id]}"
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = @merchant.merchant_bulk_discounts.create(
      percentage: params[:percentage],
      min_quality: params[:min_quality]
    )

    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
  end

  def destroy
    MerchantBulkDiscount.find(params[:merchant_bulk_discount_id]).destroy
    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
  end

  private

  def merchant_bulk_discount_params
    params.permit(:percentage, :min_quality)
  end
end
