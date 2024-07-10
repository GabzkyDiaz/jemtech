class ProductsGallery < ApplicationRecord
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image_url", "product_id", "updated_at"]
  end
end
