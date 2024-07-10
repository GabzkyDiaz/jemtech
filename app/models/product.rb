class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :cart_items
  has_many :products_galleries
  has_many :product_tags
  has_many :tags, through: :product_tags

  scope :on_sale, -> { joins(:tags).where(tags: { name: 'on_sale' }) }
  scope :recently_updated, -> { where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago) }
end
