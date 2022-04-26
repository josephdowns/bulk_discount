class MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayFacade.new
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

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to merchant_discounts_path
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    discount.update(discount_params)
    redirect_to merchant_discount_path(discount.merchant.id, discount.id)
  end

  def discount_params
    params.permit(:discount, :threshold)
  end
end
