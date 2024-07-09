class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :cart_items
  has_many :products_galleries
  has_and_belongs_to_many :tags
end
