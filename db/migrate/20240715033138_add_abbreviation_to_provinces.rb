class AddAbbreviationToProvinces < ActiveRecord::Migration[7.1]
  def change
    add_column :provinces, :abbreviation, :string
  end
end
