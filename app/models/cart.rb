class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cart_items

  validates :customer_id, presence: true
end
