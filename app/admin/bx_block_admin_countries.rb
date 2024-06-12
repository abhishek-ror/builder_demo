ActiveAdmin.register BxBlockAdmin::Country, as: "Countries"do
  menu parent: "Location"
  permit_params :name, :country_code, :phone_no_digit, :region_id, :file

  index download_links: [:csv] do
    id_column
    column :name
    column :country_code
    column :phone_no_digit
    column :region_id do |obj|
      BxBlockAdmin::Region.find(obj.region_id)&.name
    end
      column "Flag" do |img|
         link_to image_tag(img.image_url,class: 'country_flag'),admin_country_path(img)
      end
  
    actions
  end  

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :country_code
      f.input :phone_no_digit, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");', maxlength: 3 }      
      f.input :region_id,as: :select, collection: BxBlockAdmin::Region.all.map{|t| [t.name, t.id] }
      f.input :file, as: :file
    end      
    f.actions
  end
  
  show do
    attributes_table do
      row :name
      row :country_code
      row :phone_no_digit
      row :region_id do |obj|
        BxBlockAdmin::Region.find(obj.region_id)&.name
      end
      row :file do |img|
        link_to image_tag(img.image_url,class: 'country_flag'),admin_advertisement_path(img)
      end
      row :created_at
      row :updated_at
    end
  end

  # or
  #
  # permit_params do
  #   permitted = [:name, :region_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  filter :name 
  #filter :region_id
  filter :region_id, as: :select, collection: BxBlockAdmin::Region.where(id: BxBlockAdmin::Country.all.pluck(:region_id)&.uniq).map{|c| [c.name, c.id]}

end
