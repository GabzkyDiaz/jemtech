# app/services/stripe_payment_service.rb
class StripePaymentService
  def initialize(order)
    @order = order
  end

  def create_checkout_session
    Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          product_data: {
            name: 'Order',
          },
          unit_amount: (@order.total_amount * 100).to_i, # Amount in cents
          currency: 'cad',
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: "#{Rails.application.routes.url_helpers.order_url(@order)}/success",
      cancel_url: "#{Rails.application.routes.url_helpers.new_order_url}?status=cancel",
    })
  end
end
