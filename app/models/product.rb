require 'faraday'
require 'json'

class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :cart_items
  has_many :products_galleries
  has_many :product_tags
  has_many :tags, through: :product_tags

  scope :on_sale, -> { joins(:tags).where(tags: { name: 'on_sale' }) }
  scope :recently_updated, -> { where('updated_at >= ?', 3.days.ago) }

  after_save :notify_zapier, if: :on_sale_tagged?

  def self.ransackable_associations(auth_object = nil)
    ["cart_items", "category", "order_items", "product_tags", "products_galleries", "tags"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "id_value", "image_url", "name", "price", "sku", "stock_quantity", "updated_at"]
  end

  private

  def on_sale_tagged?
    tags.exists?(name: 'on_sale')
  end

  def notify_zapier
    if saved_change_to_updated_at? && on_sale_tagged?
      connection = Faraday.new(url: 'https://hooks.zapier.com/hooks/catch/19431297/23nc7rt/') do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end

      response = connection.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          product: {
            name: name,
            url: Rails.application.routes.url_helpers.product_url(self, only_path: true)
          }
        }.to_json
      end

      Rails.logger.info "Zapier response: #{response.status}, #{response.body}"
    end
  end
end
