class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cart_items, dependent: :destroy

  validates :customer_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "id", "id_value", "updated_at"]
  end

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
    province = customer.province
    gst = province.gst_rate * subtotal
    pst = province.pst_rate * subtotal
    hst = province.hst_rate * subtotal
    qst = province.qst_rate * subtotal
    gst + pst + hst + qst
  end

  def tax_breakdown
    province = customer.province
    breakdown = {}
    breakdown["GST (#{province.gst_rate * 100}%)"] = province.gst_rate * subtotal if province.gst_rate > 0
    breakdown["PST (#{province.pst_rate * 100}%)"] = province.pst_rate * subtotal if province.pst_rate > 0
    breakdown["HST (#{province.hst_rate * 100}%)"] = province.hst_rate * subtotal if province.hst_rate > 0
    breakdown["QST (#{province.qst_rate * 100}%)"] = province.qst_rate * subtotal if province.qst_rate > 0
    breakdown
  end

  def total
    subtotal + calculate_taxes
  end
end
