# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart, only: [:new, :create]

  def new
    @order = current_customer.orders.build
    build_order_from_cart(@order, @cart)

    if @order.total_amount >= minimum_amount_in_cents / 100.0
      @order.save(validate: false) # Save without validation to calculate total_amount
      begin
        @payment_intent = StripePaymentService.new(@order).create_payment_intent
      rescue => e
        flash[:alert] = "Error creating payment intent: #{e.message}"
        @payment_intent = nil
      end
    else
      flash[:alert] = "Order amount is too low to process payment."
    end
  end

  def create
    @order = current_customer.orders.build(order_params)
    if @order.save && update_customer_info
      @order.update(status: 'pending', stripe_payment_id: params[:payment_intent_id])
      redirect_to order_path(@order), notice: 'Order created successfully.'
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update_customer_info
    if current_customer.update(customer_params)
      true
    else
      false
    end
  end

  private

  def set_cart
    @cart = current_customer.current_cart
  end

  def order_params
    params.require(:order).permit(:address, :city, :province_id, :zip_code, :country, :phone, order_items_attributes: [:product_id, :quantity, :price])
  end

  def customer_params
    params.require(:customer).permit(:address, :city, :province_id, :zip_code, :country, :phone)
  end

  def build_order_from_cart(order, cart)
    cart.cart_items.each do |cart_item|
      order.order_items.build(product_id: cart_item.product_id, quantity: cart_item.quantity, price: cart_item.product.price)
    end
    order.calculate_total
  end

  def minimum_amount_in_cents
    50 # Minimum amount in cents (0.50 CAD)
  end
end
