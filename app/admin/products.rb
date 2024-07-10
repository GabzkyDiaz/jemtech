ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_id, tag_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :category
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :category
      f.input :tags, as: :check_boxes, collection: Tag.all
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :category
      row :tags do |product|
        product.tags.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :category_id, :name, :description, :price, :stock_quantity, :sku, :image_url
  #
  # or
  #
  # permit_params do
  #   permitted = [:category_id, :name, :description, :price, :stock_quantity, :sku, :image_url]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
