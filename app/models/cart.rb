class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cart_items

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "id", "id_value", "updated_at"]
  end

  validates :customer_id, presence: true
end
