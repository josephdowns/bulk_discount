class MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.discounts.create(discount_params)
    redirect_to merchant_discounts_path
  end

  def discount_params
    params.permit(:discount, :threshold)
  end
end
