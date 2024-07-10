# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'csv'

# Helper method to generate SKU
def generate_sku(product_name)
  "#{product_name.parameterize}-#{SecureRandom.hex(4)}"
end

# Define the file paths for your CSV files
laptops_file_path = Rails.root.join('db', 'Laptops_Notebooks.csv')
keyboards_file_path = Rails.root.join('db', 'Keyboards_Mice.csv')
gaming_monitors_file_path = Rails.root.join('db', 'Gaming_Monitors.csv')
desktop_systems_file_path = Rails.root.join('db', 'Desktop_Systems.csv')

# Import products from CSV
def import_products(file_path, category_name)
  CSV.foreach(file_path, headers: true) do |row|
    category = Category.find_or_create_by(name: category_name)
    product = Product.new(
      name: row['name'],
      description: row['description'],
      price: row['price'].gsub('$', '').to_f,
      image_url: row['Main Image URL'], # main image URL
      category_id: category.id,
      sku: generate_sku(row['name']),
      stock_quantity: row['stock_quantity'] || 0 # assuming stock quantity is in the CSV or default to 0
    )
    if product.save
      # Assuming gallery images are stored in a JSON array format
      gallery_images = JSON.parse(row['Product Gallery Images']).map { |img| img['Product Gallery Images-src'] }

      gallery_images.each do |image_url|
        next if image_url.nil?

        ProductsGallery.create(
          product_id: product.id,
          image_url: image_url.strip
        )
      end
    else
      puts "Product #{row['name']} could not be saved: #{product.errors.full_messages.join(', ')}"
    end
  end
end

# Import data for each category
import_products(laptops_file_path, 'Laptops / Notebooks')
import_products(keyboards_file_path, 'Keyboards & Mice')
import_products(gaming_monitors_file_path, 'Gaming Monitors')
import_products(desktop_systems_file_path, 'Desktop Systems')
