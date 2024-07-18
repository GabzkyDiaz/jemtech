ActiveAdmin.register Customer do
  permit_params :email, :first_name, :last_name, :address, :city, :province_id, :zip_code, :country, :phone, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :phone
    column :address
    column :city
    column :province
    column :zip_code
    column :country
    column :created_at
    column :updated_at
    column :encrypted_password do |customer|
      customer.encrypted_password
    end
    column :password_salt do |customer|
      customer.encrypted_password[0,29] if customer.encrypted_password.present?
    end
    actions
  end

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

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :phone
      row :address
      row :city
      row :province
      row :zip_code
      row :country do |customer|
        country = ISO3166::Country[customer.country]
        country.translations[I18n.locale.to_s] || country.iso_short_name || customer.country
      end
      row :created_at
      row :updated_at
      row :encrypted_password do |customer|
        customer.encrypted_password
      end
      row :password_salt do |customer|
        customer.encrypted_password[0,29] if customer.encrypted_password.present?
      end
    end
  end

  controller do
    def find_resource
      scoped_collection.find(params[:id])
    end

    def destroy
      resource.destroy
      flash[:notice] = "Customer was successfully deleted."
      redirect_to admin_customers_path
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = "Cannot delete customer with associated records. Please delete associated records first."
      redirect_to admin_customers_path
    end
  end
end
