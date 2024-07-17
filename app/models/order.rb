class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items

  before_save :calculate_total, unless: :persisted?

  validates :customer_id, :order_date, :status, :total_amount, presence: true
  validates :total_amount, :gst_rate, :pst_rate, :hst_rate, :qst_rate, numericality: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "gst_rate", "hst_rate", "id", "id_value", "order_date", "pst_rate", "qst_rate", "status", "total_amount", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items"]
  end

  def calculate_total
    province = Province.find(customer.province_id)
    self.gst_rate = province.gst_rate || 0.0
    self.pst_rate = province.pst_rate || 0.0
    self.hst_rate = province.hst_rate || 0.0
    self.qst_rate = province.qst_rate || 0.0

    subtotal = order_items.sum { |item| (item.price || 0) * (item.quantity || 0) }
    self.total_amount = subtotal + (subtotal * gst_rate) + (subtotal * pst_rate) + (subtotal * hst_rate) + (subtotal * qst_rate)
  end

  def subtotal
    order_items.sum { |item| item.price * item.quantity }
  end

  def gst_amount
    gst_rate * subtotal
  end

  def pst_amount
    pst_rate * subtotal
  end

  def hst_amount
    hst_rate * subtotal
  end

  def qst_amount
    qst_rate * subtotal
  end

  def tax_breakdown
    breakdown = {}
    breakdown["GST (#{gst_rate * 100}%)"] = gst_amount if gst_rate > 0
    breakdown["PST (#{pst_rate * 100}%)"] = pst_amount if pst_rate > 0
    breakdown["HST (#{hst_rate * 100}%)"] = hst_amount if hst_rate > 0
    breakdown["QST (#{qst_rate * 100}%)"] = qst_amount if qst_rate > 0
    breakdown
  end
end
