class CreateProductsGalleries < ActiveRecord::Migration[7.1]
  def change
    create_table :products_galleries do |t|
      t.references :product, null: false, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
