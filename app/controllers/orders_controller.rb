class OrdersController < ApplicationController
  def new
    @order = current_customer.orders.build
  end

  def create
    @order = current_customer.orders.build(order_params)
    if @order.save
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:address, :city, :province_id, :zip_code, :country, order_items_attributes: [:product_id, :quantity, :price])
  end
end
