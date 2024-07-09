class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :address
      t.string :city
      t.references :province, null: false, foreign_key: true
      t.string :zip_code
      t.string :country

      t.timestamps
    end
  end
end
