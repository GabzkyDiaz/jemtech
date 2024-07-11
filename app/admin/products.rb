ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_id, tag_ids: []

  scope :all, default: true
  scope :on_sale do |products|
    products.joins(:tags).where(tags: { name: 'on_sale' })
  end

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

  filter :name
  filter :price
  filter :category
  filter :tags, as: :check_boxes, collection: -> { Tag.all }
end
