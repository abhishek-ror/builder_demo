ActiveAdmin.register ServiceShipping, as: "Destination Service" do
  config.batch_actions = false
  permit_params :title
  # actions :all, :except => [:new]
  index download_links: false do 
    selectable_column
    id_column
    column :title
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
    end
    f.actions
  end

  show do
    attributes_table do   
      row :title
    end
  end 
end