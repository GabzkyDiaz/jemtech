ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_id, :stock_quantity, :sku, :main_image, gallery_images: [], tag_ids: []

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
    column :main_image do |product|
      if product.main_image.attached?
        image_tag url_for(product.main_image), size: "50x50"
      elsif product.image_url.present?
        image_tag product.image_url, size: "50x50"
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :category
      f.input :stock_quantity, input_html: { value: f.object.stock_quantity || 0 }
      f.input :tags, as: :check_boxes, collection: Tag.all
      f.input :main_image, as: :file

      if f.object.persisted?
        if f.object.main_image.attached?
          div do
            image_tag url_for(f.object.main_image), size: "100x100"
          end
        elsif f.object.image_url.present?
          div do
            image_tag f.object.image_url, size: "100x100"
          end
        end
      end

      f.input :gallery_images, as: :file, input_html: { multiple: true }

      if f.object.persisted? && f.object.gallery_images.attached?
        div do
          f.object.gallery_images.each do |img|
            span do
              image_tag url_for(img), size: "100x100"
            end
          end
        end
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :category
      row :stock_quantity
      row :sku
      row :tags do |product|
        product.tags.map(&:name).join(", ")
      end
      row :main_image do |product|
        if product.main_image.attached?
          image_tag url_for(product.main_image)
        elsif product.image_url.present?
          image_tag product.image_url
        end
      end
      row :gallery_images do |product|
        if product.gallery_images.attached?
          product.gallery_images.each do |img|
            span do
              image_tag url_for(img), size: "100x100"
            end
          end
        end
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

  controller do
    def generate_sku(product_name)
      "#{product_name.parameterize}-#{SecureRandom.hex(4)}"
    end

    def create
      @product = Product.new(permitted_params[:product])
      @product.stock_quantity ||= 0
      @product.sku ||= generate_sku(@product.name)
      if @product.save
        redirect_to admin_product_path(@product), notice: "Product created successfully."
      else
        Rails.logger.debug "Product errors: #{@product.errors.full_messages.join(', ')}"
        render :new
      end
    end

    def update
      @product = Product.find(params[:id])
      @product.assign_attributes(permitted_params[:product])
      @product.sku ||= generate_sku(@product.name)
      if @product.save
        redirect_to admin_product_path(@product), notice: "Product updated successfully."
      else
        Rails.logger.debug "Product errors: #{@product.errors.full_messages.join(', ')}"
        render :edit
      end
    end
  end
end
