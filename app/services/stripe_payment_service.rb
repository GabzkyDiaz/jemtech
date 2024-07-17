# app/services/stripe_payment_service.rb
class StripePaymentService
  def initialize(order)
    @order = order
  end

  def create_payment_intent
    Stripe::PaymentIntent.create({
      amount: (@order.total_amount * 100).to_i, # Amount in cents
      currency: 'cad', # Set currency to CAD
      payment_method_types: ['card'],
    })
  end
end
