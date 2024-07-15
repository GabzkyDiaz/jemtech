class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "gst_rate", "hst_rate", "id", "id_value", "order_date", "pst_rate", "qst_rate", "status", "total_amount", "updated_at"]
  end

  validates :customer_id, :order_date, :status, :total_amount, presence: true
  validates :total_amount, :gst_rate, :pst_rate, :hst_rate, :qst_rate, numericality: true
end
