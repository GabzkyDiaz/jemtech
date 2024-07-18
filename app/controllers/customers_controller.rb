class CustomersController < ApplicationController
  before_action :authenticate_customer!

  def orders
    @orders = current_customer.orders.includes(:order_items).order(created_at: :desc)
  end

  def profile
    @customer = current_customer
  end

  def update_profile
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to customer_profile_path, notice: 'Information updated successfully.'
    else
      render :profile
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :address, :city, :province_id, :zip_code, :country, :phone)
  end
end
