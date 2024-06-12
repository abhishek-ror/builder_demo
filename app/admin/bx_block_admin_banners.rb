ActiveAdmin.register BxBlockAdmin::Banner , as: "Banner Images" do
  menu false
  permit_params :priority, image_attributes: [:id, :image]
  
  form do |f|
    f.inputs
    f.inputs "Images" do
      f.has_many :image, new_record: 'Attach Image', remove_record: 'Remove Image',heading: false do |cd|
        hint = image_tag(cd.object.image.url) if cd.object&.image&.url
        cd.input :image, as: :file, :hint => hint
      end
    end

    f.actions
  end  
end