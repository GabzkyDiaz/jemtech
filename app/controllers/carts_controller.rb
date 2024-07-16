class CartsController < ApplicationController
  before_action :authenticate_customer!
  before_action :find_cart

  def show
    @cart_items = @cart.cart_items
  end

  def add_item
    product = Product.find(params[:product_id])
    @cart.add_product(product, 1)
    redirect_to cart_path
  end

  def update_item
    @cart.update_quantity(params[:product_id], params[:quantity].to_i)
    redirect_to cart_path
  end

  def remove_item
    @cart.remove_product(params[:product_id])
    redirect_to cart_path
  end

  def empty_cart
    @cart.cart_items.destroy_all
    redirect_to cart_path
  end

  private

  def find_cart
    @cart = current_customer.current_cart
  end
end
