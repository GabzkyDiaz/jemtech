class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    event = nil
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400 and return
    end

    case event['type']
    when 'checkout.session.completed'
      session = event['data']['object']
      handle_checkout_session(session)
    when 'payment_intent.succeeded'
      payment_intent = event['data']['object']
      handle_payment_intent(payment_intent)
    else
      puts "Unhandled event type: #{event['type']}"
    end

    render json: { message: 'success' }, status: 200
  end

  private

  def handle_checkout_session(session)
    order = Order.find_by(id: session.metadata.order_id)
    if order
      order.update(stripe_payment_id: session.payment_intent, status: 'paid', order_date: Time.current)
      order.customer.current_cart.cart_items.destroy_all
    end
  end

  def handle_payment_intent(payment_intent)
    order = Order.find_by(stripe_payment_id: payment_intent.id)
    if order
      order.update(status: 'paid', order_date: Time.current)
      order.customer.current_cart.cart_items.destroy_all
    end
  end
end
