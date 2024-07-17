class OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart, only: [:new, :create]

  def new
    @order = current_customer.orders.build
  end

  def create
    @order = current_customer.orders.build(order_params)
    if @order.save && update_customer_info
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update_customer_info
    if current_customer.update(customer_params)
      redirect_to new_order_path, notice: 'Information updated successfully.'
    else
      redirect_to new_order_path, alert: 'Failed to update information.'
    end
  end

  private

  def set_cart
    @cart = current_customer.current_cart
  end

  def order_params
    params.require(:order).permit(:address, :city, :province_id, :zip_code, :country, order_items_attributes: [:product_id, :quantity, :price])
  end

  def customer_params
    params.require(:customer).permit(:address, :city, :province_id, :zip_code, :country, :phone)
  end
end
