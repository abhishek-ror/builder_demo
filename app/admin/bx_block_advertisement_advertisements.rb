ActiveAdmin.register BxBlockAdvertisement::Advertisement, as: "Advertisement" do

	config.per_page = 10
  permit_params :name, :description, :image

	index download_links: [:csv] do
		column :name
		column :description
	    column "Image" do |img|
	        link_to image_tag(img.image.blob.service_url,class: 'my_index_image_size'),admin_advertisement_path(img)
	    end
	    
		actions
	end

	form do |f|
		f.inputs do
		  f.input :name
		  f.input :description
		  f.input :image, as: :file

		end

		f.actions
	end

	show do
	    attributes_table do
	      row :name
	      row :description
	      row :image do |ad|
	        image_tag ad.image.blob.service_url, class: 'my_image_size'
	      end
    	end
	end
  	filter :name  
end