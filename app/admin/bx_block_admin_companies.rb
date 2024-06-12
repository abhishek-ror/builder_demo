ActiveAdmin.register BxBlockAdmin::Company, as: "Companies" do
  menu parent: "Cars"

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :logo 
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  index download_links: [:csv] do
    id_column
		column :name
	  column "Logo" do |img|
	        link_to image_tag(img.logo_url,class: 'service_logo_size'),bx_block_admin_all_companies_path(img)
	  end
	    
		actions
	end

  show do
    attributes_table do
      row :name
      row :logo do |ad|
        image_tag ad.logo_url, class: 'service_logo_size'
      end
    end
end

  filter :name
  filter :models

  form do |f|
    f.inputs do
      f.input :name
      f.input :logo, as: :file
     
    end      
    f.actions
  end

end
