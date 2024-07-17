ActiveAdmin.register Order do
  permit_params :customer_id, :order_date, :status, :total_amount, :gst_rate, :pst_rate, :hst_rate, :qst_rate,
                order_items_attributes: [:id, :order_id, :product_id, :quantity, :price, :_destroy]

  index do
    selectable_column
    id_column
    column :customer
    column :order_date
    column :status
    column :total_amount
    actions
  end

  show do
    attributes_table do
      row :customer
      row :order_date
      row :status
      row :total_amount
      row :gst_rate
      row :pst_rate
      row :hst_rate
      row :qst_rate
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :customer
      f.input :order_date
      f.input :status
      f.input :total_amount
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate
      f.input :qst_rate
    end

    f.has_many :order_items, allow_destroy: true do |item|
      item.input :product
      item.input :quantity
      item.input :price
    end

    f.actions
  end
end
