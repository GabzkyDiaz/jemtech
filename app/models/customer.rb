class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders
  has_many :carts

  validates :first_name, :last_name, :email, :phone, :address, :city, :province_id, :zip_code, :country, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A\+?\d{10,15}\z/ }
  validates :province_id, numericality: { only_integer: true }
end
