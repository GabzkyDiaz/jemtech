ActiveAdmin.register StaticPage do
  permit_params :title, :content

  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :text # Use built-in :text input type
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :title
    column :content do |page|
      raw(page.content.truncate(100)) # Display truncated content
    end
    actions
  end

  show do
    attributes_table do
      row :title
      row :content do |page|
        raw(page.content)
      end
    end
  end
end
