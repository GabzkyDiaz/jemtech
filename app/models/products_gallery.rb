class ProductsGallery < ApplicationRecord
  belongs_to :product

  validates :product_id, :image_url, presence: true
  validates :product_id, numericality: { only_integer: true }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image_url", "product_id", "updated_at"]
  end
end
