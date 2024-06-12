ActiveAdmin.register BxBlockVehicleShipping::VehicleOrder, as: "Vehicle Order" do

	actions :all, :except => [:new]

    permit_params :continent, :country, :state, :area, :country_code,
    	:phone_number, :full_phone_number, :vehicle_selling_id, :status,
     	:final_sale_amount, :status_updated_at, :final_invoice_payment_status,
     	:notes, :order_request_id, :admin_user_id, :account_id, :instant_deposit_amount,
     	:instant_deposit_amount, :vehicle_selling_inspection_id, :instant_deposit_status, :final_invoice, :payment_receipt, :passport, :other_documents  =>[]
    
    DOC_TYPE =  'application/pdf'
    DISPLAY_MSG = 'No documents uploaded'  

  form do |f|
    f.inputs do
      f.input :continent
      f.input :country
      f.input :state
      f.input :country_code, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");', maxlength: 5 }
      f.input :phone_number, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");', maxlength: 20 }
      f.input :full_phone_number, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");', maxlength: 20 }
      f.input :status, include_blank: false

      if params[:bx_block_vehicle_shipping_vehicle_order]&.dig(:instant_deposit_amount).blank? && params[:bx_block_vehicle_shipping_vehicle_order]&.dig(:final_sale_amount).present?
        f.input :instant_deposit_amount, as: :string, input_html: { placeholder: 'Instant Deposit Amount is required', style: 'border: 1px solid red;'}
      else
        instant_deposit_amount_value = params.dig(:bx_block_vehicle_shipping_vehicle_order, :instant_deposit_amount) || f.object.instant_deposit_amount
        f.input :instant_deposit_amount, as: :string, input_html: { value: instant_deposit_amount_value, oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
      end

      # f.input :instant_deposit_status
      
      if params[:bx_block_vehicle_shipping_vehicle_order]&.dig(:final_sale_amount).blank? && params[:bx_block_vehicle_shipping_vehicle_order]&.dig(:instant_deposit_amount).present?
        f.input :final_sale_amount, as: :string, input_html: { placeholder: 'Final Sale Amount is required', style: 'border: 1px solid red;'}
      else
        final_sale_amount_value = params.dig(:bx_block_vehicle_shipping_vehicle_order, :final_sale_amount) || f.object.final_sale_amount
        f.input :final_sale_amount, as: :string, input_html: { value: final_sale_amount_value, oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
      end

      f.input :final_invoice_payment_status

      # f.input :final_invoice, as: :file
      f.input :final_invoice, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.final_invoice.attached? ? (f.object.final_invoice.is_a?(Array) ? f.object.final_invoice.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.final_invoice.filename, rails_blob_path(f.object.final_invoice, disposition: 'attachment'))) : content_tag(:span, DISPLAY_MSG)

      # f.input :payment_receipt, as: :file
      f.input :payment_receipt, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.payment_receipt.attached? ? (f.object.payment_receipt.is_a?(Array) ? f.object.payment_receipt.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.payment_receipt.filename, rails_blob_path(f.object.payment_receipt, disposition: 'attachment'))) : content_tag(:span, DISPLAY_MSG)

      f.input :passport, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.passport.attached? ? (f.object.passport.is_a?(Array) ? f.object.passport.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.passport.filename, rails_blob_path(f.object.passport, disposition: 'attachment'))) : content_tag(:span, DISPLAY_MSG)

      # f.input :other_documents, as: :file, input_html: {multiple: true}
      f.input :other_documents, as: :file, input_html: { multiple: true, accept: DOC_TYPE }, hint: f.object.other_documents.attached? ? f.object.other_documents.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : content_tag(:span, DISPLAY_MSG)

    end
    f.actions
  end

  controller do
    def update
      @vehicle_order = BxBlockVehicleShipping::VehicleOrder.find(params[:id])
      if params[:bx_block_vehicle_shipping_vehicle_order][:instant_deposit_amount].present? && params[:bx_block_vehicle_shipping_vehicle_order][:final_sale_amount].blank?
        flash[:error] = "Please update the final sale amount when updating the instant deposit amount."
        redirect_to edit_admin_vehicle_order_path(@vehicle_order, 'bx_block_vehicle_shipping_vehicle_order[instant_deposit_amount]' => params[:bx_block_vehicle_shipping_vehicle_order][:instant_deposit_amount]) and return
      end
      if params[:bx_block_vehicle_shipping_vehicle_order][:final_sale_amount].present? && params[:bx_block_vehicle_shipping_vehicle_order][:instant_deposit_amount].blank?
        flash[:error] = "Please update the instant deposit amount when updating the final sale amount."
        redirect_to edit_admin_vehicle_order_path(@vehicle_order, 'bx_block_vehicle_shipping_vehicle_order[final_sale_amount]' => params[:bx_block_vehicle_shipping_vehicle_order][:final_sale_amount]) and return
      end

      super
    end
  end

  show do
    attributes_table do
      row :order_request_id, humanize_name: false
      row :account
      row :car_ad
      row :continent
      row :country
      row :state
      row :area
      row :country_code
      row :phone_number
      row :full_phone_number
      row :status
      row :created_at
      row :instant_deposit_amount
      # row :instant_deposit_status
      row :final_sale_amount
      row :status_updated_at
      row :final_invoice_payment_status
      row :final_invoice do |ad|
        link_to(ad.final_invoice.filename , ad.final_invoice.blob.service_url, target: :_blank) if ad.final_invoice.present?
      end
      row :payment_receipt do |ad|
        link_to(ad.payment_receipt.filename,ad.payment_receipt.blob.service_url, target: :_blank) if ad.payment_receipt.present?
      end
      row :passport do |ad|
        link_to(ad.passport.filename,ad.passport.blob.service_url, target: :_blank) if ad.passport.present?
      end

      row :other_documents do |ad|
       ul do
        ad.other_documents.each do |doc|
          li do 
            link_to(doc.filename,rails_blob_path(doc,disposition: "attachment"))
          end
        end
       end
      end
      
    end
  end
end