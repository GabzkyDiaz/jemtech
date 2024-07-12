class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  validates :customer_id, :order_date, :status, :total_amount, presence: true
  validates :total_amount, :gst_rate, :pst_rate, :hst_rate, :qst_rate, numericality: true
end
