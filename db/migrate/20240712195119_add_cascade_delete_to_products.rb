class AddCascadeDeleteToProducts < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :order_items, :products
    add_foreign_key :order_items, :products, on_delete: :cascade

    remove_foreign_key :cart_items, :products
    add_foreign_key :cart_items, :products, on_delete: :cascade

    remove_foreign_key :products_galleries, :products
    add_foreign_key :products_galleries, :products, on_delete: :cascade

    remove_foreign_key :product_tags, :products
    add_foreign_key :product_tags, :products, on_delete: :cascade
  end
end
