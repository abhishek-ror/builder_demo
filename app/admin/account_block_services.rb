ActiveAdmin.register BxBlockServices::Service, as: "Services" do

    permit_params :logo, :description, :title

    index download_links: [:csv] do
        id_column
		column :title
		column :description
	    column "Logo" do |img|
	        link_to image_tag(img.logo_url,class: 'service_logo_size'),admin_service_path(img)
	    end
	    
		actions
	end
    form do |f|
      f.inputs do
        f.input :logo, as: :file
        f.input :title
        f.input :description
       
      end      
      f.actions
    end

	show do
	    attributes_table do
	      row :title
	      row :description
	      row :logo do |ad|
	        image_tag ad.logo_url, class: 'service_logo_size'
	      end
    	end
	end

    filter :title 
    filter :description
  
  end
  