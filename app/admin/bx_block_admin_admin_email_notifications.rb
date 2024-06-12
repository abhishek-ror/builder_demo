ActiveAdmin.register BxBlockAdminEmailNotification::AdminEmailNotification, as: "Email Notifications" do
  config.batch_actions = false
  
  # actions :all, :except => [:new]
	permit_params :notification_name, :content

  index :download_links => false do 
    selectable_column
    id_column
    column :notification_name
    column :content do |resource|
      sanitize(resource.content)
    end
    actions
  end
	
  form do |f|
    f.inputs do
      f.input :notification_name
      f.input :content, as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [['bold', 'italic','underline', 'strike'],['link', 'image'], [{ 'size': ['small', false, 'large', 'huge'] }],['blockquote', 'code-block'], [{ 'color': [] }, { 'background': [] }],[{ 'font': [] }],[{ 'align': [] }],[{ 'script': 'sub'}, { 'script': 'super' }],[{ 'direction': 'rtl' }],[{ 'header': [1, 2, 3, 4, 5, 6, false] }],] }, placeholder: 'Type something...', theme: 'snow' } } }     
    end
    f.actions
  end

  show do
    attributes_table do
      row :notification_name
      row :content do |resource|
        sanitize(resource.content)
      end
    end
	end

  # remove_filter :created_at
  # remove_filter :updated_at

  filter :notification_name, as: :select, collection: BxBlockAdminEmailNotification::AdminEmailNotification.notification_names 
  filter :content
end