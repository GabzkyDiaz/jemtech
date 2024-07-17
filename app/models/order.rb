# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items

  before_save :calculate_total

  validates :customer_id, :order_date, :status, :total_amount, presence: true
  validates :total_amount, :gst_rate, :pst_rate, :hst_rate, :qst_rate, numericality: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "gst_rate", "hst_rate", "id", "id_value", "order_date", "pst_rate", "qst_rate", "status", "total_amount", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items"]
  end

  def calculate_total
    province = customer.province
    self.gst_rate = province.gst_rate || 0.0
    self.pst_rate = province.pst_rate || 0.0
    self.hst_rate = province.hst_rate || 0.0
    self.qst_rate = province.qst_rate || 0.0

    subtotal = order_items.sum { |item| (item.price || 0) * (item.quantity || 0) }
    gst = gst_rate * subtotal
    pst = pst_rate * subtotal
    hst = hst_rate * subtotal
    qst = qst_rate * subtotal

    self.total_amount = subtotal + gst + pst + hst + qst
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

  private

  def subtotal
    order_items.sum { |item| (item.price || 0) * (item.quantity || 0) }
  end
end
