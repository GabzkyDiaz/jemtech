class Province < ApplicationRecord
  has_many :customers

  validates :name, :gst_rate, :pst_rate, :hst_rate, :qst_rate, presence: true
  validates :gst_rate, :pst_rate, :hst_rate, :qst_rate, numericality: true
end
