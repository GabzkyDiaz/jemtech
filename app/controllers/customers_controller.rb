class CustomersController < ApplicationController
  before_action :authenticate_customer!

  def orders
    @orders = current_customer.orders.includes(:order_items).order(created_at: :desc)
  end
end
