class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders
  has_many :carts

  def self.ransackable_associations(auth_object = nil)
    ["carts", "orders", "province"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["address", "city", "country", "created_at", "email", "encrypted_password", "first_name", "id", "id_value", "last_name", "phone", "province_id", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at", "zip_code"]
  end

  validates :first_name, :last_name, :email, :phone, :address, :city, :province_id, :zip_code, :country, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A\+?\d{10,15}\z/ }
  validates :province_id, numericality: { only_integer: true }

  # Add Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
