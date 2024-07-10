# In lib/tasks/create_tags_based_on_categories.rake

namespace :tags do
  desc "Create tags based on categories and associate them with products"
  task create_from_categories: :environment do
    Category.find_each do |category|
      tag = Tag.find_or_create_by(name: category.name)

      category.products.find_each do |product|
        unless product.tags.include?(tag)
          product.tags << tag
          puts "Tag '#{tag.name}' added to Product '#{product.name}'"
        end
      end
    end
  end
end
