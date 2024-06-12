ActiveAdmin.register BxBlockWhatsappNumber::WhatsAppNumber, as: "WhatsApp" do
  permit_params :whatsapp_number, :country_code
  actions :all, :except => [:new, :destroy] 

  form do |f|
  	f.input :country_code, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");', maxlength: 5 }
    f.input :whatsapp_number, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");' }
    f.actions
  end

  show do
    attributes_table do
      row :country_code
      row :whatsapp_number
    end
  end

  index :download_links => false do 
    id_column
    column :country_code
    column :whatsapp_number
    actions
  end
end