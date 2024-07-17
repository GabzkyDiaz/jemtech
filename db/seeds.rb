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

=begin
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


# Clear existing static pages
StaticPage.delete_all

# Seed data for About Us page
StaticPage.create(
  title: 'About Us',
  content: <<-HTML
    <p class="text-lg text-gray-600 mb-6">Welcome to Jemtech Computer Store, your premier destination for all your computer needs.</p>
    <p class="text-lg text-gray-700 mb-6">Jemtech Computer Store is a premier technology retailer based in Winnipeg, Canada. Specializing in providing a wide array of computer products and accessories, the company has established itself as a trusted name in the local tech community due to its strong commitment to quality and customer satisfaction.</p>
    <p class="text-lg text-gray-700 mb-6">With a team of 35 dedicated employees and over 10 years in the business, Jemtech offers an extensive selection of products including the latest laptops, keyboards, cables, and other essential computer peripherals.</p>
    <p class="text-lg text-gray-700 mb-6">Our target demographic includes individual consumers and businesses looking for reliable computer products and accessories. Whether you are a technology enthusiast, a small to medium-sized business owner, a student, or a professional, Jemtech has the right products for you.</p>
    <p class="text-lg text-gray-700 mb-6">Our new e-commerce platform is designed to offer an intuitive and user-friendly online shopping experience, providing detailed product descriptions and secure payment options to enhance customer satisfaction and loyalty.</p>
    <p class="text-lg text-gray-700">Thank you for choosing Jemtech Computer Store. We look forward to serving you and meeting all your computer needs.</p>
  HTML
)

# Seed data for Contact Us page
StaticPage.create(
  title: 'Contact Us',
  content: <<-HTML
    <p class="text-lg text-gray-600 mb-6">We'd love to hear from you! Reach out to us through any of the following methods:</p>
    <div class="mb-8">
      <h3 class="text-lg font-semibold mb-4">Office Address</h3>
      <p class="text-lg text-gray-700">316 Ross Avenue, Winnipeg, Canada</p>
    </div>
    <div class="mb-8">
      <h3 class="text-lg font-semibold mb-4">Phone</h3>
      <p class="text-lg text-gray-700">(431) 556-4625</p>
    </div>
    <div class="mb-8">
      <h3 class="text-lg font-semibold mb-4">Email</h3>
      <a href="mailto:jemtech.shop@gmail.com" class="text-lg text-blue-500 underline">jemtech.shop@gmail.com</a>
    </div>
  HTML
)
  adding for branch adding again for branch add add
=end
