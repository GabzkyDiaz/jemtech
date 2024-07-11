class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :cart_items
  has_many :products_galleries
  has_many :product_tags
  has_many :tags, through: :product_tags

  scope :on_sale, -> { joins(:tags).where(tags: { name: 'on_sale' }) }
  scope :recently_updated, -> { where('updated_at >= ?', 3.days.ago) }

  def self.ransackable_associations(auth_object = nil)
    ["cart_items", "category", "order_items", "product_tags", "products_galleries", "tags"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "id_value", "image_url", "name", "price", "sku", "stock_quantity", "updated_at"]
  end
end
