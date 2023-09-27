class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = MerchantBulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = MerchantBulkDiscount.new
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = MerchantBulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = MerchantBulkDiscount.find(params[:id])

    if @merchant_bulk_discount.update(merchant_bulk_discount_params)
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = "Error: #{error_message(@merchant_bulk_discount.errors)}"
      render :edit
    end
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = @merchant.merchant_bulk_discounts.create(merchant_bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    MerchantBulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def merchant_bulk_discount_params
    params.require(:merchant_bulk_discount).permit(:percentage, :min_quality)
  end
end
