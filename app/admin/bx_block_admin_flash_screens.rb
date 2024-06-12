ActiveAdmin.register BxBlockAdmin::FlashScreen, as: "Flash Screens" do


  permit_params :screen_type, :title, :description_title, :description, :offer, :tips_for_advertisment_posting, :offer_title, :tips_title, images_attributes: [:id, :image, :_destroy]
  
  index do
    selectable_column
    id_column
    column :screen_type
    column :title
    column :description_title
    column :description do |record|
      div  do
        record.description&.html_safe
      end
    end
    column :offer_title
    column :tips_title
    column :offer do |record|
      div  do
        record.offer&.html_safe
      end
    end
    column :tips_for_advertisment_posting do |record|
      div  do
        record.tips_for_advertisment_posting&.html_safe
      end
    end
    actions
  end

  show do
  attributes_table do
    row :screen_type
    row :title
    row :description_title

    row :description do |record|
      div  do
        record.description&.html_safe
      end
    end
    row :offer_title
    row :tips_title

    row :offer do |record|
      div  do
        record.offer&.html_safe
      end
    end

    row :tips_for_advertisment_posting do |record|
      div  do
        record.tips_for_advertisment_posting&.html_safe
      end
    end

    row "Images" do
        resource&.images&.map{|image| link_to image_tag(image.image_url,class: 'country_flag')}
    end
    row :created_at
    row :updated_at
  end
  end

  form do |f|
    f.inputs :screen_type, :title
    f.inputs :description_title, label: 'Description Title'
    f.inputs do
      f.input :description, as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [['bold', 'italic','underline', 'strike'],['link', 'image'], [{ 'size': ['small', false, 'large', 'huge'] }],['blockquote', 'code-block'], [{ 'color': [] }, { 'background': [] }],[{ 'font': [] }],[{ 'align': [] }],[{ 'script': 'sub'}, { 'script': 'super' }],[{ 'direction': 'rtl' }],[{ 'header': [1, 2, 3, 4, 5, 6, false] }],] }, placeholder: 'Type something...', theme: 'snow' } } }
    end
    
    f.inputs :offer_title, label: 'Offer Title'
    f.inputs :tips_title, label: 'Tips for Advertisment Title'

    f.inputs do
      f.input :offer, label: 'What we offer', as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [['bold', 'italic','underline', 'strike'],['link', 'image'], [{ 'size': ['small', false, 'large', 'huge'] }],['blockquote', 'code-block'], [{ 'color': [] }, { 'background': [] }],[{ 'font': [] }],[{ 'align': [] }],[{ 'script': 'sub'}, { 'script': 'super' }],[{ 'direction': 'rtl' }],[{ 'header': [1, 2, 3, 4, 5, 6, false] }],] }, placeholder: 'Type something...', theme: 'snow' } } }
    end
    f.inputs do
      f.input :tips_for_advertisment_posting, as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [['bold', 'italic','underline', 'strike'],['link', 'image'], [{ 'size': ['small', false, 'large', 'huge'] }],['blockquote', 'code-block'], [{ 'color': [] }, { 'background': [] }],[{ 'font': [] }],[{ 'align': [] }],[{ 'script': 'sub'}, { 'script': 'super' }],[{ 'direction': 'rtl' }],[{ 'header': [1, 2, 3, 4, 5, 6, false] }],] }, placeholder: 'Type something...', theme: 'snow' } } }
    end
    f.inputs "Images" do
      f.has_many :images, new_record: 'Attach Image', remove_record: 'Remove Image',heading: false do |cd|
        hint = image_tag(cd.object.image.url, style: "height: 10%; width: 10%") if cd.object&.image&.url
        cd.input :image, as: :file,  :hint => hint
      end
    end
    f.actions
  end

  filter :screen_type, as: :select, collection: {"buy":0, "sell":1, "inspection":2, "shipping":3}
  filter :title
  filter :description_title
  filter :offer
  filter :offer_title
  filter :tips_title
  
end