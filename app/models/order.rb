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
    province = Province.find(province_id)
    self.gst_rate = province.gst_rate
    self.pst_rate = province.pst_rate
    self.hst_rate = province.hst_rate
    self.qst_rate = province.qst_rate

    subtotal = order_items.sum { |item| item.price * item.quantity }
    self.total_amount = subtotal + subtotal * gst_rate + subtotal * pst_rate + subtotal * hst_rate + subtotal * qst_rate
  end
end
