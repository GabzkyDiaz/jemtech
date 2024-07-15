ActiveAdmin.register Customer do
  permit_params :email, :first_name, :last_name, :address, :city, :province_id, :zip_code, :country, :phone, :password, :password_confirmation

  form do |f|
    f.inputs "Customer Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :address
      f.input :city
      f.input :province
      f.input :zip_code
      f.input :country, as: :select, collection: ISO3166::Country.all.map { |country| [country.translations[I18n.locale.to_s] || country.name, country.alpha2] }
      f.input :phone
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
