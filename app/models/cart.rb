class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cart_items, dependent: :destroy

  validates :customer_id, presence: true

  def add_product(product, quantity)
    cart_item = cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = (cart_item.quantity || 0) + quantity
    cart_item.quantity = 1 if cart_item.quantity < 1  # Ensure the quantity is at least 1
    cart_item.save
  end

  def update_quantity(product_id, quantity)
    cart_item = cart_items.find_by(product_id: product_id)
    cart_item.update(quantity: quantity)
  end

  def remove_product(product_id)
    cart_item = cart_items.find_by(product_id: product_id)
    cart_item.destroy
  end

  def subtotal
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  def calculate_taxes
    customer.province.gst_rate * subtotal
  end

  def total
    subtotal + calculate_taxes
  end
end
