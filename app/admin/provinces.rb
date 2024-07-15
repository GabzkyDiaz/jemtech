ActiveAdmin.register Province do
  permit_params :name, :abbreviation, :gst_rate, :pst_rate, :hst_rate, :qst_rate

  index do
    selectable_column
    id_column
    column :name
    column :abbreviation
    column :gst_rate
    column :pst_rate
    column :hst_rate
    column :qst_rate
    actions
  end

  filter :name
  filter :abbreviation # Ensure this line is included
  filter :gst_rate
  filter :pst_rate
  filter :hst_rate
  filter :qst_rate

  form do |f|
    f.inputs do
      f.input :name
      f.input :abbreviation
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate
      f.input :qst_rate
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :abbreviation
      row :gst_rate
      row :pst_rate
      row :hst_rate
      row :qst_rate
    end
    active_admin_comments
  end
end
