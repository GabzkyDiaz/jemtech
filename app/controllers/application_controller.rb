class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address, :city, :province_id, :zip_code, :country, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address, :city, :province_id, :zip_code, :country, :phone])
  end

  def set_cart
    @cart = current_customer.current_cart if customer_signed_in?
  end
end
