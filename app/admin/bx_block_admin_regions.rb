ActiveAdmin.register BxBlockAdmin::Region, as: "Regions" do
  menu parent: "Location" 
  permit_params :name, :phone_no_digit, image_attributes: [:id, :image, :_destroy], countries_attributes: [:id, :name, :country_code, :phone_no_digit, :_destroy, :file]

  VALIDATION = 'this.value = this.value.replace(/[^0-9+]/g, "");'

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Region" do
      f.input :name
      f.input :phone_no_digit, as: :string, input_html: { oninput: VALIDATION, maxlength: 3 }
      f.inputs "Image", for:  [:image, f.object.image || f.object.build_image] do |_cd|
        hint = image_tag(_cd.object.image&.url, style: "height: 10%; width: 10%") if _cd.object.image&.url
        _cd.input :image, as: :file, :hint => hint
      end
    end

    f.inputs "Countries" do
      f.has_many :countries, heading: false , allow_destroy: true do |cd|
        hint = image_tag(cd.object.file.service_url, style: "height: 10%; width: 10%") if cd.object.file&.attached?
        cd.input :name
        cd.input :country_code, as: :string, input_html: { oninput: VALIDATION, maxlength: 5 }
        cd.input :phone_no_digit, as: :string, input_html: { oninput: VALIDATION, maxlength: 3 }
        cd.input :file, as: :file, :hint => hint
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :phone_no_digit
      row :file do |img|
        link_to image_tag(img.image_url, class: 'region_flag', style: "height: 10%; width: 10%") if img.image.present?
      end
      row :created_at
      row :updated_at
    end
  end

  filter :name  
end