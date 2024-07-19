require 'open-uri'

# Define the models (assuming you have Product and ActiveStorage setup)
class Product < ApplicationRecord
  has_one_attached :main_image
  has_many_attached :gallery_images
end

class ProductsGallery < ApplicationRecord
  belongs_to :product
end

# Process each product to download and attach images
Product.find_each do |product|
  # Attach the main image
  if product.image_url.present?
    begin
      main_image_file = URI.open(product.image_url)
      product.main_image.attach(io: main_image_file, filename: File.basename(product.image_url))
      puts "Main image attached for Product ID: #{product.id}"
    rescue => e
      puts "Failed to attach main image for Product ID: #{product.id}, Error: #{e.message}"
    end
  end

  # Attach the gallery images
  product.products_galleries.each do |gallery|
    if gallery.image_url.present?
      begin
        gallery_image_file = URI.open(gallery.image_url)
        product.gallery_images.attach(io: gallery_image_file, filename: File.basename(gallery.image_url))
        puts "Gallery image attached for Product ID: #{product.id}, Gallery ID: #{gallery.id}"
      rescue => e
        puts "Failed to attach gallery image for Product ID: #{product.id}, Gallery ID: #{gallery.id}, Error: #{e.message}"
      end
    end
  end

  product.save
end

puts "Images have been successfully attached to Active Storage!"
