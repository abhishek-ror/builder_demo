ActiveAdmin.register BxBlockAdmin::TermsAndCondition, as: "Terms And Conditions" do

  permit_params :description

  index :download_links => false do 
    selectable_column
    id_column
    column :description do |resource|
      sanitize(resource.description)
    end
    column :created_at
  	column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :description, as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [['bold', 'italic','underline', 'strike'],['link', 'image'], [{ 'size': ['small', false, 'large', 'huge'] }],['blockquote', 'code-block'], [{ 'color': [] }, { 'background': [] }],[{ 'font': [] }],[{ 'align': [] }],[{ 'script': 'sub'}, { 'script': 'super' }],[{ 'direction': 'rtl' }],[{ 'header': [1, 2, 3, 4, 5, 6, false] }],] }, placeholder: 'Type something...', theme: 'snow' } } }
    end

    f.actions
  end

  show do
    attributes_table do
      row :description do |resource|
        sanitize(resource.description)
      end
      row :created_at
  		row :updated_at
    end
	end

end