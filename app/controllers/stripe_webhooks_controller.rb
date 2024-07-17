# app/controllers/stripe_webhooks_controller.rb
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
    when 'payment_intent.succeeded'
      payment_intent = event['data']['object']
      order = Order.find_by(stripe_payment_id: payment_intent['id'])
      order.update(status: 'paid') if order
    end

    render json: { message: 'success' }, status: 200
  end
end
