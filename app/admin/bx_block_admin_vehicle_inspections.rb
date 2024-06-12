ActiveAdmin.register BxBlockAdmin::VehicleInspection, as: "Vehicle Inspection" do
  menu parent: "Inspection"
  STYLE = "height: 10%; width: 10%"
  REGSPEC = "Regional Spec"
  INSPECTSTATUS = "Inspection Status"
  DOC_TYPE =  'application/pdf'
  SHOW_MSG = 'No documents uploaded'

  permit_params :city_id, :advertisement_url, :about, :seller_country_code, :make_year, :status, :final_invoice_status, :instant_deposit_status, :vin_number, :seller_mobile_number, :seller_email, :seller_name, :price, :inspection_amount, :final_sale_amount, :account_id, :admin_user_id, :model_id, :notes_for_the_inspector, :notes_for_the_admin, :instant_deposit_link, :instant_deposit_amount, :inspector_id, :car_ad_id, :instant_deposit_receipt, :payment_receipt,  :inspection_invoice, :final_invoice, images_attributes: [:id, :image, :item_type, :_destroy], inspection_report_attributes: [:id, :google_drive_url, inspection_forms_attributes: [:id, :image, :item_type, :_destroy], reports_attributes: [:id, :image, :item_type, :_destroy], images_attributes: [:id, :image, :item_type, :_destroy]]

  controller do
    def update
      @vehicle_inspection = BxBlockAdmin::VehicleInspection.find(params[:id])
      if params[:vehicle_inspection][:instant_deposit_amount].present? && params[:vehicle_inspection][:final_sale_amount].blank?
        flash[:error] = "Please update the final sale amount when updating the instant deposit amount."
        redirect_to edit_admin_vehicle_inspection_path(@vehicle_inspection, 'vehicle_inspection[instant_deposit_amount]' => params[:vehicle_inspection][:instant_deposit_amount]) and return
      end
      if params[:vehicle_inspection][:final_sale_amount].present? && params[:vehicle_inspection][:instant_deposit_amount].blank?
        flash[:error] = "Please update the instant deposit amount when updating the final sale amount."
        redirect_to edit_admin_vehicle_inspection_path(@vehicle_inspection, 'vehicle_inspection[final_sale_amount]' => params[:vehicle_inspection][:final_sale_amount]) and return
      end
      
      super
    end
  end

  index do
    id_column
    column :model
    column :city
    column :make_year
    column REGSPEC, :vin_number
    column :seller_name
    column :seller_country_code
    column :seller_mobile_number
    column :seller_email
    column :price
    column :inspection_amount
    column :inspector
    column :Buyer do |record|
      link_to("#{record&.account&.full_name}","/admin/accounts/#{record&.account&.id}") 
    end
    column :advertisement_url
    column INSPECTSTATUS, :status
    
    actions
  end

  show do
    attributes_table do
      row :city
      row :model
      row :inspector
      row :Buyer do |record|
        link_to("#{record&.account&.full_name}","/admin/accounts/#{record&.account&.id}") 
      end
      row :advertisement_url #do |adv|
      #   link_to(adv.advertisement_url, adv.advertisement_url, target: :_blank)
      # end
      row INSPECTSTATUS do |resource|
        resource.status
      end
      row REGSPEC do |resource|
        resource.vin_number
      end

      row :price

      ["make_year", "about", "seller_country_code", "seller_name", "seller_mobile_number", "seller_email", "inspection_amount","notes_for_the_inspector", "notes_for_the_admin"].each do |column|
        row column.to_sym
      end

      row "Vehicle Images" do
        resource&.images&.map{|image| image_tag(image.image.url,style: STYLE) }
        # if resource&.images.present?
        #   resource&.images&.map{|image| image_tag(image.image.url,style: STYLE) }
        # else
        #   if resource.auto_images.attached?
        #   ul do
        #     resource.auto_images.each do |img|
        #       li do
        #         # image_tag(img.filename, img.blob.service_url, target: :_blank)
        #         image_tag img.blob.service_url, style: STYLE
        #       end
        #     end
        #   end
        # end
        # end
      end

      row "Google Drive Url" do |resource|
        # link_to(resource.inspection_report&.google_drive_url, resource.inspection_report&.google_drive_url, target: :_blank)
        resource.inspection_report&.google_drive_url
      end
      row "Inspection Images" do
        resource&.inspection_report&.images&.map{|image| image_tag(image.image.url,style: STYLE) }
        #resource.inspection_report&.images&.map{|image| link_to(image.image.identifier, image.image.url, target: :_blank) }
      end
      row "Inspection Reports" do
        resource&.inspection_report&.inspection_forms&.map{|image| image_tag(image.image.url,style: STYLE) }
        #resource.inspection_report&.inspection_forms&.map{|image| link_to(image.image.identifier, image.image.url, target: :_blank) }
      end

      row "payment_receipt" do
        link_to(resource.payment_receipt&.attachment.name.titleize, rails_blob_path(resource.payment_receipt, disposition: "networking_pdf")) rescue nil
      end
      
      # row "Inspection Reports" do
      #   resource&.inspection_report&.reports&.map{|image| image_tag(image.image.url,style: STYLE) }
      #   #resource.inspection_report&.reports&.map{|image| link_to(image.image.identifier, image.image.url, target: :_blank) }
      # end

      row :instant_deposit_amount
      #row :instant_deposit_link
      row :instant_deposit_link do |ins|
        link_to(ins.instant_deposit_link, ins.instant_deposit_link, target: :_blank)
      end
      row :final_sale_amount
      row :instant_deposit_status
      row "Instant Deposit Receipt" do
        link_to(resource.instant_deposit_receipt&.attachment.name.titleize, rails_blob_path(resource.instant_deposit_receipt, disposition: "networking_pdf")) rescue nil
      end
      # row "Instant Deposit Receipt" do |img|
      #   #link_to image_tag(img.image_url,class: 'country_flag')
      #    image_tag(img.image_url,style: STYLE) if img.instant_deposit_receipt.attached?
      # end
      
      #row :car_order
      # row :final_invoice_status do
      #   resource&.car_order&.final_invoice_payment_status
      # end
      # row 'Payment Receipt' do
      #   if resource&.car_order.present?
      #     link_to(resource.car_order&.payment_receipt&.attachment.name.titleize, rails_blob_path(resource.car_order&.payment_receipt, disposition: "networking_pdf")) rescue nil
      #   end
      # end
      # row 'Passport/Reg Doc' do
      #   link_to(resource.car_order.passport&.attachment.name.titleize, rails_blob_path(resource.car_order.passport, disposition: "networking_pdf")) rescue nil
      # end
      # row "Misc/Other Attachments" do
      #   if resource&.car_order&.other_documents&.attached?
      #     resource&.car_order&.other_documents.map{|doc| link_to(doc.filename, doc.blob.service_url, target: :_blank) }
      #   end
      #   # resource&.car_order&.other_documents.map{|image| link_to(image.image.identifier, image.image.url, target: :_blank) }
      # end

      row :inspection_invoice do |ad|
        link_to(ad.inspection_invoice.filename,url_for(ad.inspection_invoice), target: :_blank) if ad.inspection_invoice.present?
      end

      # row :instant_deposit_link do |ad|
      #   link_to(ad.instant_deposit_link.filename,url_for(ad.instant_deposit_link), target: :_blank) if ad.instant_deposit_link.present?
      # end

      row :final_invoice do |ad|
        link_to(ad.final_invoice.filename,url_for(ad.final_invoice), target: :_blank) if ad.final_invoice.present?
      end

    end
  end

  form do |f|
    f.semantic_errors *f.object.errors
    f.inputs do
      f.input :account_id, :label => 'Customer', as: :select, collection: AccountBlock::Account.all.map{|c| [c.full_name, c.id]}
      f.input :city_id, :label => 'City', as: :select, collection: BxBlockAdmin::City.all.map{|c| [c.name, c.id]}
      f.input :advertisement_url
      f.input :model_id, :label => 'Model', as: :select, collection: BxBlockAdmin::Model.all.map{|c| [c.name, c.id]}
      # f.input :car_ad_id, :label => 'Car Ad', as: :select, collection: BxBlockAdmin::CarAd.where(status: 'posted').map{|c| [c.id, c.id]}
      f.input :inspector_id, :label => 'Inspector', as: :select, collection: AccountBlock::Account.where(user_type: 'inspector').map{|c| [c.full_name, c.id]}

      f.input :seller_country_code, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");', maxlength: 5 }
      f.input :seller_mobile_number, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");' }
      
      f.input :vin_number, :label => 'Regional_spec', as: :select, collection: BxBlockAdmin::RegionalSpec.all.map{|c| [c.name, c.name]}
      ["make_year", "about", "price", "seller_name", "seller_email", "inspection_amount","notes_for_the_inspector", "notes_for_the_admin"].each do |column|
        f.input column.to_sym, as: :string
      end

      f.input :status, label: 'Status', ảs: :select, collection: BxBlockAdmin::VehicleInspection.statuses.keys
    end
    # f.inputs :except => ['admin_user']
    # f.inputs :admin_user_id, as: :select, collection: AdminUser.all.map{|u| [u.email, u.id]}
    f.inputs "Images" do
      f.has_many :images, heading: false, allow_destroy: true  do |cd|
        hint = image_tag(cd.object.image.url, style: STYLE) if cd.object.image.url
        cd.input :image, as: :file, :hint => hint, input_html: {style: STYLE}
        cd.input :item_type, as: :hidden, :input_html => { :value => 'images' }
      end
    end

    f.inputs 'Inspection Report', :for => [:inspection_report, f.object.inspection_report || BxBlockAdmin::InspectionReport.new] do |fi|
      fi.input :google_drive_url
      
      fi.has_many :images, heading: 'Images', allow_destroy: true do |cd|
        hint = image_tag(cd.object.image.url, style: STYLE) if cd.object.image.url
        # hint = image_tag(cd.object.image.service_url, style: STYLE) if cd.object&.image&.attached?
        cd.input :image, as: :file, :hint => hint, input_html: {style: STYLE}
        cd.input :item_type, as: :hidden, :input_html => { :value => 'images' }
      end

      fi.has_many :inspection_forms, heading: "Inspection Reports", allow_destroy: true do |cd|
        hint = image_tag(cd.object.image.url, style: STYLE) if cd.object.image.url
        cd.input :image, as: :file, :hint => hint
        cd.input :item_type, as: :hidden, :input_html => { :value => 'inspection_forms' }
      end

      # fi.has_many :reports, heading: "Reports", allow_destroy: true do |cd|
      #   hint = image_tag(cd.object.image.url, style: STYLE) if cd.object.image.url()
      #   cd.input :image, as: :file, :hint => hint
      #   cd.input :item_type, as: :hidden, :input_html => { :value => 'reports' }
      # end

      # fi.inputs "Report", :for => [:report, fi.object.report || fi.object.build_report] do |fr|
      #   hint = image_tag(fr.object.image.url) if fr.object.image.url
      #   fr.input :image, as: :file, :hint => hint
      # end
    end

    f.inputs 'Instant Deposit' do

      if params[:vehicle_inspection]&.dig(:instant_deposit_amount).blank? && params[:vehicle_inspection]&.dig(:final_sale_amount).present?
        f.input :instant_deposit_amount, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");', placeholder: 'Instant Deposit Amount is required', style: 'border: 1px solid red;'}
      else
        instant_deposit_amount_value = params.dig(:vehicle_inspection, :instant_deposit_amount) || f.object.instant_deposit_amount
        f.input :instant_deposit_amount, as: :string, input_html: {oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");', value: instant_deposit_amount_value }
      end

      f.input :instant_deposit_link, as: :string

      if params[:vehicle_inspection]&.dig(:final_sale_amount).blank? && params[:vehicle_inspection]&.dig(:instant_deposit_amount).present?
        f.input :final_sale_amount, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");', placeholder: 'Final Sale Amount is required', style: 'border: 1px solid red;'}
      else
        final_sale_amount_value = params.dig(:vehicle_inspection, :final_sale_amount) || f.object.final_sale_amount
        f.input :final_sale_amount, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");', value: final_sale_amount_value }
      end

      # f.input :instant_deposit_receipt, as: :file
      f.input :instant_deposit_receipt, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.instant_deposit_receipt.attached? ? (f.object.instant_deposit_receipt.is_a?(Array) ? f.object.instant_deposit_receipt.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.instant_deposit_receipt.filename, rails_blob_path(f.object.instant_deposit_receipt, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)

      f.input :instant_deposit_status, label: 'Status', ảs: :select, collection: BxBlockAdmin::VehicleInspection.instant_deposit_statuses.keys
    end

    # f.inputs "Invoice Documents" do
    #   f.input :final_invoice_status, label: 'Status', ảs: :select, collection: BxBlockAdmin::VehicleInspection.final_invoice_statuses.keys
    #   f.input :payment_receipt, as: :file, label: 'Payment Receipt'
    #   f.input :document, as: :file, label: 'Passport Copy/Company Reg.'

    #   f.has_many :other_documents, heading: 'Misc / Other attachments', allow_destroy: true do |cd|
    #     hint = image_tag(cd.object.image.url, style: STYLE) if cd.object.image.url
    #     cd.input :image, as: :file, :hint => hint
    #     cd.input :item_type, as: :hidden, :input_html => { :value => 'other_documents' }
    #   end
    # end

    # f.inputs "Inspection Report Uploaded Images" do
    #   f.object.inspection_report&.images&.records&.each do |img|
    #     li class: "some_class" do
    #       figure do
    #         img src: img.service_url, alt: "Photo", style: STYLE
    #         figcaption img.filename
    #       end

    #       a "Delete", href: delete_inspection_image_admin_vehicle_inspection_path(img.id), "data-method": :delete, "data-confirm": "Are you sure?"
    #     end
    #   end
    # end

    # f.input :inspection_invoice, as: :file
    f.input :inspection_invoice, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.inspection_invoice.attached? ? (f.object.inspection_invoice.is_a?(Array) ? f.object.inspection_invoice.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.inspection_invoice.filename, rails_blob_path(f.object.inspection_invoice, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)

    # f.input :final_invoice, as: :file
    f.input :final_invoice, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.final_invoice.attached? ? (f.object.final_invoice.is_a?(Array) ? f.object.final_invoice.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.final_invoice.filename, rails_blob_path(f.object.final_invoice, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)    
    
    f.actions
  end

  # member_action :delete_inspection_image, method: :delete do
  #   @pic = ActiveStorage::Attachment.find(params[:id])
  #   @pic.purge_later
  #   redirect_back(fallback_location: edit_admin_vehicle_inspection_path)   
  # end
  model_ids = BxBlockAdmin::VehicleInspection.all.pluck(:model_id)&.uniq
  city_ids  = BxBlockAdmin::VehicleInspection.all.pluck(:city_id)&.uniq
  inspector_ids = BxBlockAdmin::VehicleInspection.all.pluck(:inspector_id)&.uniq
  filter :model_id,as: :select, collection:  BxBlockAdmin::Model.where(id: model_ids).map{|c| [c.name, c.id]}
  filter :city_id,as: :select, collection:  BxBlockAdmin::City.where(id: city_ids).map{|c| [c.name, c.id]}
  filter :make_year, label: "Make Year"
  filter :seller_name, label: "Seller Name"
  filter :seller_country_code, label: "Seller Country Code"
  filter :seller_mobile_number, label: "Seller Mobile Number"
  filter :seller_email, label: "Seller Email"
  filter :price
  filter :inspection_amount, label: "Inspection Amount"
  filter :inspector_id,as: :select, collection: AccountBlock::Account.where(id: inspector_ids).map{|c| [c.full_name, c.id]}
  filter :vin_number,  label: REGSPEC
  filter :advertisement_url, label: "Advertisement URL"
  filter :status, label: INSPECTSTATUS, as: :select, collection: {'inprogress': 0, 'payment_pending': 1, 'payment_confirmed': 2, 'payment_failed': 3, 'processing': 4, 'completed': 5, 'accepted_for_inspection': 6, 'rejected': 7}
end