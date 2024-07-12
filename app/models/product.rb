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

  validates :category_id, :name, :description, :price, :stock_quantity, :sku, presence: true
  validates :price, numericality: true
  validates :stock_quantity, numericality: { only_integer: true }

  before_validation :set_defaults, on: :create

  private

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "id_value", "image_url", "name", "on_sale", "price", "sku", "stock_quantity", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["cart_items", "category", "order_items", "product_tags", "products_galleries", "tags"]
  end

  def set_defaults
    self.stock_quantity ||= 0
    self.sku ||= generate_sku(name)
    self.image_url ||= ActionController::Base.helpers.asset_path('defaultimage.png')
  end

  def generate_sku(product_name)
    "#{product_name.parameterize}-#{SecureRandom.hex(4)}"
  end

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
