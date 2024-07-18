class StripePaymentService
  def initialize(order)
    @order = order
  end

  def create_checkout_session
    session = Stripe::Checkout::Session.create({
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
      success_url: "#{Rails.application.routes.url_helpers.success_order_url(@order)}",
      cancel_url: "#{Rails.application.routes.url_helpers.cancel_order_url(@order)}",
      metadata: {
        order_id: @order.id
      }
    })
    @order.update(stripe_payment_id: session.payment_intent)
    session
  end
end
