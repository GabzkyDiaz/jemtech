class OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart, only: [:new, :create, :update_customer_info]

  def new
    @order = current_customer.orders.build
    build_order_from_cart(@order, @cart)

    if @order.total_amount >= minimum_amount_in_cents / 100.0
      @order.save(validate: false) # Save without validation to calculate total_amount
      begin
        @checkout_session = StripePaymentService.new(@order).create_checkout_session
      rescue => e
        flash[:alert] = "Error creating checkout session: #{e.message}"
        @checkout_session = nil
      end
    else
      flash[:alert] = "Order amount is too low to process payment."
    end
  end

  def create
    @order = current_customer.orders.build(order_params)
    if @order.save && update_customer_info
      @order.update(status: 'pending', stripe_payment_id: params[:session_id])
      redirect_to @order, notice: 'Order created successfully.'
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update_customer_info
    if current_customer.update(customer_params)
      @order = current_customer.orders.build
      build_order_from_cart(@order, @cart)
      respond_to do |format|
        format.html { redirect_to new_order_path, notice: 'Customer information updated.' }
        format.json { render json: tax_breakdown_json(@order) }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { error: 'Failed to update customer information.' }, status: :unprocessable_entity }
      end
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

  def tax_breakdown_json(order)
    {
      subtotal: number_to_currency(order.subtotal, unit: "CAD$"),
      gst: number_to_currency(order.gst_amount, unit: "CAD$"),
      pst: number_to_currency(order.pst_amount, unit: "CAD$"),
      hst: number_to_currency(order.hst_amount, unit: "CAD$"),
      qst: number_to_currency(order.qst_amount, unit: "CAD$"),
      total: number_to_currency(order.total_amount, unit: "CAD$")
    }
  end
end
