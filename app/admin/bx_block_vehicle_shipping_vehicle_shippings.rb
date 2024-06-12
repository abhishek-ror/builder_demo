ActiveAdmin.register BxBlockVehicleShipping::VehicleShipping,as: "Vehicle Shipping" do
    config.batch_actions = false

  actions :all, :except => [:new] 

  permit_params :region, :country, :state, :area, :year, :make, :model, :regional_specs, :country_code, :phone_number, :source_country, :pickup_port, :destination_country, :destination_port, :shipping_instruction, :account_id, :final_destination_charge, :approved_by_admin, :vehicle_pickup,:onboard,:shipment_noti,:arrived,:destination_service, :export_title, :notes_for_admin, :payment_confirmation_status, :status, :shipping_status, :estimated_time_of_departure, :estimated_time_of_arrival, :shipping_line, :container_number, :bl_number, :tracking_link, :delivery_status, :payment_link, :service_shippings_id, :review, :shipping_invoice, :export_certificate, :payment_receipt, :passport,  :conditional_report,:invoice_amount, :delivery_invoice, :payment_type, :car_images => [], :image => [], :customer_payment_receipt => [], :condition_pictures =>[], :delivery_proof => [], :other_documents =>[],:misc_docs => [],:unloading_image => [], :loading_image => [], image_attributes: [:id, :image, :_destroy]

  ACCOUNT_BLOCK_ACCOUNT = "AccountBlock::Account"
  DOC_TYPE =  'application/pdf'
  SHOW_MSG = 'No documents uploaded'

  member_action :approve, method: :post do
    approve_notification = "Push Notification admin approval"
    approve_account = ACCOUNT_BLOCK_ACCOUNT
    if resource.shipping_invoice.present? && resource.final_destination_charge.present?
      resource.update(approved_by_admin: "true")
      redirect_to admin_vehicle_shippings_path, notice: "Vehicle shipment approved updated successfully."
      unless resource.vehicle_order.present?
        BxBlockPushNotifications::PushNotification.create(account_id: resource.account_id, remarks: "Notification regarding the final shipping amount", notify_type: approve_notification, push_notificable_id: resource.account_id, push_notificable_type: approve_account, is_read: false, logo: @base_url, notification_type: "final shipment amount by admin in vehicle shipping", notification_type_id: resource.id)
      end
    else 
      error_messages = []
      error_messages << "Shipping invoice is missing." unless resource.shipping_invoice.present?
      error_messages << "Final Destination charge is missing." unless resource.final_destination_charge.present?
      redirect_to admin_vehicle_shippings_path, alert: "Please fill the required field of vehicle shipping. #{error_messages.join(' ')}"
    end
  end

  member_action :picked_up, method: :post do
        account = "AccountBlock::Notification"
        message = "Your car has been picked up and being prepared for shipping at warehouse"
        notice = "Push Notification for pickup"
    if resource.payment_confirmation_status == "confirmed"    
      if resource.export_title.present? && resource.condition_pictures.present? && resource.condition_pictures.length <= 15 && resource.conditional_report.present?
        if resource.vehicle_order.present?
          buy_request = resource.vehicle_order

          BxBlockPushNotifications::PushNotification.create(account_id: buy_request.account_id, remarks: message , notify_type: notice, push_notificable_id: buy_request.account_id, push_notificable_type:ACCOUNT_BLOCK_ACCOUNT, is_read: false, logo: @base_url, notification_type: "prepared for shipping at warehouse for order", notification_type_id: buy_request.order_request_id)
        else
          BxBlockPushNotifications::PushNotification.where(account_id: resource.account_id, notification_type_id: resource.id).where.not(remarks: "Your car has been picked up and being prepared for shipping at warehouse").update_all(completion_check: true)
          BxBlockPushNotifications::PushNotification.create(account_id: resource.account_id, remarks: message, notify_type:notice, push_notificable_id: resource.account_id, push_notificable_type: ACCOUNT_BLOCK_ACCOUNT, is_read: false, logo: @base_url, notification_type: "prepared for shipping at warehouse", notification_type_id: resource.id)
        end
        resource.update(vehicle_pickup: "true")
        resource.update(shipping_status: "picked up")
        redirect_to admin_vehicle_shippings_path, notice: "Vehicle shipment picked up updated successfully."
      else 
        error_messages = []
        error_messages << "Export title is missing." unless resource.export_title.present?
        error_messages << "Condition pictures are missing or exceed the maximum count (15)." unless resource.condition_pictures.present? && resource.condition_pictures.length <= 15
        error_messages << "Conditional report is missing." unless resource.conditional_report.present?
        redirect_to admin_vehicle_shippings_path, alert: "Please fill the required field of vehicle shipping. #{error_messages.join(' ')}"
      end
    else
      error_messages = []
      error_messages << "Payment status is not confirmed please confirmed" unless resource.payment_confirmation_status == "confirmed"
      redirect_to admin_vehicle_shippings_path, alert: "Please fill the required field of vehicle shipping. #{error_messages.join(' ')}"
    end
  end

  member_action :onboard, method: :post do
    onboard_notification = "Push Notification for onboarding"
    onboard_account = ACCOUNT_BLOCK_ACCOUNT

    if resource.estimated_time_of_departure.present? && resource.estimated_time_of_arrival.present? && resource.shipping_line.present? && resource.container_number.present? && resource.bl_number.present? && resource.tracking_link.present? && resource.loading_image.present?
      resource.update(onboard: "true")
      p resource
      resource.update(shipping_status: "onboarded")
      redirect_to admin_vehicle_shippings_path, notice: "Vehicle shipment onboard updated successfully."
      BxBlockPushNotifications::PushNotification.where(account_id: resource.account_id, notification_type_id: resource.id).update_all(completion_check: true)
      BxBlockPushNotifications::PushNotification.create!(account_id: resource.account_id, remarks: "The car has been onboarded, click here to view shipping & tracking details", notify_type: onboard_notification, push_notificable_id: resource.account_id, push_notificable_type: onboard_account, is_read: false, logo: @base_url, notification_type: "Your car has been onboarded.", notification_type_id: resource.id)
    else
      error_messages = []
      error_messages << "Estimated time of departure is missing." unless resource.estimated_time_of_departure.present?
      error_messages << "Estimated time of arrival is missing." unless resource.estimated_time_of_arrival.present?
      error_messages << "Shipping line is missing." unless resource.shipping_line.present?
      error_messages << "Container number is missing." unless resource.container_number.present?
      error_messages << "BL number is missing." unless resource.bl_number.present?
      error_messages << "Tracking link is missing." unless resource.tracking_link.present?
      error_messages << "Loading image is missing." unless resource.loading_image.present?

      redirect_to admin_vehicle_shippings_path, alert: "Please fill the required field of vehicle shipping. #{error_messages.join(' ')}"
    end
  end

  member_action :arrived, method: :post do
    arrived_notification = "Push Notification shipment arrival"
    arrived_account = ACCOUNT_BLOCK_ACCOUNT
    if resource.unloading_image.present?
      resource.update(arrived: "true")
      resource.update(shipping_status: "arrived")
      redirect_to admin_vehicle_shippings_path, notice: "Notification regarding shipment arrived at the destination port."
      BxBlockPushNotifications::PushNotification.where(account_id: resource.account_id, notification_type_id: resource.id).update_all(completion_check: true)
      BxBlockPushNotifications::PushNotification.create(account_id: resource.account_id, remarks: "Your shipment has arrived at the destination port", notify_type: arrived_notification, push_notificable_id: resource.account_id, push_notificable_type: arrived_account, is_read: false, logo: @base_url, notification_type: "shipment arrived at destination port", notification_type_id: resource.id)
    else
      error_messages = []
      error_messages << "Unloading image is missing." unless resource.unloading_image.present?
      redirect_to admin_vehicle_shippings_path, alert: "Please fill the required field of vehicle shipping. #{error_messages.join(' ')}"
    end
  end

  member_action :destination_service, method: :post do
    destination_notification = "Push Notification for destination_service"
    destination_account = ACCOUNT_BLOCK_ACCOUNT
    notice = "Notification regarding destination services and delivery"
    if resource.invoice_amount.present? && resource.service_shippings_id.present? && resource.delivery_invoice.present? && resource.delivery_proof.present?
      service_shipping = ServiceShipping.find_by(id: resource.service_shippings_id)
      if service_shipping&.title == "Unloading,customs clearance, delivery & close the order" || service_shipping&.title == "Unloading,customs clearance & close the order"
        if resource.payment_link.present?
          resource.update(destination_service: "true")
          resource.update(shipping_status: "delivered")
          redirect_to admin_vehicle_shippings_path, notice: notice
          BxBlockPushNotifications::PushNotification.where(account_id: resource.account_id, notification_type_id: resource.id).update_all(completion_check: true)
          BxBlockPushNotifications::PushNotification.create(account_id: resource.account_id, remarks: notice, notify_type: destination_notification, push_notificable_id: resource.account_id, push_notificable_type: destination_account, is_read: false, logo: @base_url, notification_type: "destination_service", notification_type_id: resource.id)
        else 
          error_messages = []
          error_messages << "Payment link is missing." unless resource.payment_link.present?
          redirect_to admin_vehicle_shippings_path, alert: "Please fill the required field of vehicle shipping. #{error_messages.join(' ')}"
        end
      else 
        resource.update(destination_service: "true")
        resource.update(shipping_status: "delivered")
        redirect_to admin_vehicle_shippings_path, notice: notice
        BxBlockPushNotifications::PushNotification.where(account_id: resource.account_id, notification_type_id: resource.id).update_all(completion_check: true)
          
          BxBlockPushNotifications::PushNotification.create(account_id: resource.account_id, remarks: notice, notify_type: destination_notification, push_notificable_id: resource.account_id, push_notificable_type: destination_account, is_read: false, logo: @base_url, notification_type: "destination_service", notification_type_id: resource.id)
      end
    else
      error_messages = []
      error_messages << "Invoice amount is missing." unless resource.invoice_amount.present?
      error_messages << "Destination Service is missing." unless resource.service_shippings_id.present?
      error_messages << "Delivery Invoice is missing." unless resource.delivery_invoice.present?
      error_messages << "Delivery Proof is missing." unless resource.delivery_proof.present?
      redirect_to admin_vehicle_shippings_path, alert: "Please fill the required field of vehicle shipping. #{error_messages.join(' ')}"
    end
  end

  member_action :approve_payment, method: :post do
    if resource.customer_payment_receipt.present?
      notice = "Notification regarding approved payment"
      redirect_to admin_vehicle_shippings_path, notice: notice
      BxBlockPushNotifications::PushNotification.where(account_id: resource.account_id, notification_type_id: resource.id).update_all(completion_check: true)
      BxBlockPushNotifications::PushNotification.create(account_id: resource.account_id, remarks: "Your shipment is delivered, Kindly give us review", notify_type: "Push Notification", push_notificable_id: resource.account_id, push_notificable_type: "AccountBlock::Account", is_read: false, logo: @base_url, notification_type: "delivered review notification", notification_type_id: resource.id)
    else
      error_messages = []
      error_messages << "Customer payment receipt is missing." unless resource.customer_payment_receipt.present?
      redirect_to admin_vehicle_shippings_path, alert: "Please fill the required field of vehicle shipping. #{error_messages.join(' ')}"
    end
  end

  member_action :car_shipment, method: :post do
    shipment_notification = "Push Notification for car shipment"
    shipment_account = ACCOUNT_BLOCK_ACCOUNT
    resource.update(shipment_noti: "true")
    redirect_to admin_vehicle_shippings_path, notice: "Vehicle shipment updated successfully."
    BxBlockPushNotifications::PushNotification.where(account_id: resource.account_id, notification_type_id: resource.id).update_all(completion_check: true)
    BxBlockPushNotifications::PushNotification.create(account_id: resource.account_id, remarks: "Notification regarding the shipment of the car", notify_type: shipment_notification, push_notificable_id: resource.account_id, push_notificable_type: shipment_account, is_read: false, logo: @base_url, notification_type: "car_shipment", notification_type_id: resource.id)
  end

  index download_links: [:csv] do 
    id_column
    column :make
    column :model
    column :source_country
    column :pickup_port
    column :destination_country
    column :destination_port
    column :final_destination_charge
    
    actions
    
    actions defaults: false do |vehicle_shipping|
      if vehicle_shipping.approved_by_admin == false
        button_to "Approve", approve_admin_vehicle_shipping_path(vehicle_shipping.id), method: :post 
      end
    end

    actions defaults: false do |vehicle_pickup|
      if vehicle_pickup.approved_by_admin == true
        if vehicle_pickup.vehicle_pickup == false 
          button_to 'Picked Up', picked_up_admin_vehicle_shipping_path(vehicle_pickup.id), method: :post
        end
      else
        button_to 'Picked Up', '#', disabled: true
      end
    end

    actions defaults: false do |onboard|
      if onboard.vehicle_pickup == true
        if onboard.onboard == false
          button_to "On Board", onboard_admin_vehicle_shipping_path(onboard.id), method: :post 
        end
      else
        button_to 'On Board', '#', disabled: true
      end
    end

    actions defaults: false do |shipment_noti|
      if shipment_noti.onboard == true
        if shipment_noti.shipment_noti == false
          button_to "Shipment", car_shipment_admin_vehicle_shipping_path(shipment_noti.id), method: :post 
        end
      else
        button_to 'Shipment', '#', disabled: true
      end
    end

    actions defaults: false do |arrived|
      if arrived.shipment_noti == true
        if arrived.arrived == false
          button_to "Arrived", arrived_admin_vehicle_shipping_path(arrived.id), method: :post 
        end
      else
        button_to 'Arrived', '#', disabled: true
      end
    end

    actions defaults: false do |destination_service|
      if destination_service.arrived == true
        if destination_service.destination_service == false
          button_to "Destination Service", destination_service_admin_vehicle_shipping_path(destination_service.id), method: :post 
        end
      else
        button_to 'Destination Service', '#', disabled: true
      end
    end

    actions defaults: false do |approve_payment|
      if approve_payment.destination_service == true
        check_payment = BxBlockPushNotifications::PushNotification.where(remarks: "Your shipment is delivered, Kindly give us review", notification_type_id: approve_payment.id).present?
        if check_payment == false
          button_to "Approve Payment", approve_payment_admin_vehicle_shipping_path(approve_payment.id), method: :post 
        end
      else
        button_to 'Approve Payment', '#', disabled: true
      end
    end

  end

  

  form do |f|
    f.inputs do
  
      f.inputs "Approve"do

        f.input :final_destination_charge, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }

        f.input :shipping_invoice, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.shipping_invoice.attached? ? (f.object.shipping_invoice.is_a?(Array) ? f.object.shipping_invoice.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.shipping_invoice.filename, rails_blob_path(f.object.shipping_invoice, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)
        
      end

      f.inputs "Picked Up" do

          f.input :payment_confirmation_status, include_blank: false

          f.input :export_title, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.export_title.attached? ? (f.object.export_title.is_a?(Array) ? f.object.export_title.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.export_title.filename, rails_blob_path(f.object.export_title, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)

          f.input :condition_pictures, as: :file, input_html: { multiple: true, accept: 'image/*' }, hint: f.object.condition_pictures.attached? ? f.object.condition_pictures.map { |image| image_tag(url_for(image), height: '100') }.join.html_safe : content_tag(:span, 'No images uploaded')

          f.input :conditional_report, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.conditional_report.attached? ? (f.object.conditional_report.is_a?(Array) ? f.object.conditional_report.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.conditional_report.filename, rails_blob_path(f.object.conditional_report, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)

      end

      f.inputs "On Board" do

        f.input :estimated_time_of_departure, min: DateTime.current, start_year: DateTime.current.year
        f.input :estimated_time_of_arrival, min: DateTime.current, start_year: DateTime.current.year
        f.input :shipping_line
        f.input :container_number
        f.input :bl_number
        f.input :tracking_link
        f.input :loading_image, as: :file, input_html: { multiple: true, accept: 'image/*' }, hint: f.object.loading_image.attached? ? f.object.loading_image.map { |image| image_tag(url_for(image), height: '100') }.join.html_safe : content_tag(:span, 'No images uploaded')

      end

      f.inputs "Arrived" do

        f.input :unloading_image, as: :file, input_html: { multiple: true, accept: 'image/*' }, hint: f.object.unloading_image.attached? ? f.object.unloading_image.map { |image| image_tag(url_for(image), height: '100') }.join.html_safe : content_tag(:span, 'No images uploaded')

      end

      f.inputs "Destination Service" do 

        f.input :invoice_amount, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }

        f.input :delivery_invoice, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.delivery_invoice.attached? ? (f.object.delivery_invoice.is_a?(Array) ? f.object.delivery_invoice.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.delivery_invoice.filename, rails_blob_path(f.object.delivery_invoice, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)

        f.input :delivery_proof, as: :file, input_html: { multiple: true, accept: DOC_TYPE }, hint: f.object.delivery_proof.attached? ? f.object.delivery_proof.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : content_tag(:span, SHOW_MSG)

        f.input :service_shippings_id, label: 'Destination Service', :as => :select, :collection => ServiceShipping.all.collect {|destionation| [destionation.title, destionation.id] }, :include_blank => false, :input_html => { :class => 'chzn-select', :width => 'auto', "data-placeholder" => 'Click' }
        f.input :payment_type, :include_blank => false, :input_html => { :class => 'link-select', :width => 'auto', "data-placeholder" => 'Click' }
        f.input :payment_link

      end

      f.inputs "Others" do 

        f.input :region
        f.input :country
        f.input :state
        f.input :area
        f.input :country_code, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");', maxlength: 5 }
        f.input :phone_number, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");', maxlength: 20 }
        f.input :year
        f.input :make
        f.input :model
        f.input :regional_specs
        f.input :source_country
        f.input :pickup_port
        f.input :destination_country
        f.input :destination_port
        f.input :shipping_instruction
        f.input :status, include_blank: false
        f.input :shipping_status, include_blank: false

        # f.input :export_certificate, as: :file
        f.input :export_certificate, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.export_certificate.attached? ? (f.object.export_certificate.is_a?(Array) ? f.object.export_certificate.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.export_certificate.filename, rails_blob_path(f.object.export_certificate, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)

        # f.input :payment_receipt, as: :file

        # f.input :passport, as: :file
        f.input :passport, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.passport.attached? ? (f.object.passport.is_a?(Array) ? f.object.passport.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.passport.filename, rails_blob_path(f.object.passport, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)

        # f.input :car_images, as: :file, input_html: {multiple: true}
        f.input :car_images, as: :file, input_html: { multiple: true, accept: 'image/*' }, hint: f.object.car_images.attached? ? f.object.car_images.map { |image| image_tag(url_for(image), height: '100') }.join.html_safe : content_tag(:span, 'No images uploaded')

        #f.input :misc_docs, as: :file, input_html: {multiple: true}

        f.input :notes_for_admin

        # f.input :payment_receipt, as: :file
         f.input :payment_receipt, as: :file, input_html: { accept: DOC_TYPE }, hint: f.object.payment_receipt.attached? ? (f.object.payment_receipt.is_a?(Array) ? f.object.payment_receipt.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : link_to(f.object.payment_receipt.filename, rails_blob_path(f.object.payment_receipt, disposition: 'attachment'))) : content_tag(:span, SHOW_MSG)

        # f.input :other_documents, as: :file, input_html: {multiple: true}
        
        f.input :other_documents, as: :file, input_html: { multiple: true, accept: DOC_TYPE }, hint: f.object.other_documents.attached? ? f.object.other_documents.map { |document| link_to(document.filename, rails_blob_path(document, disposition: 'attachment')) }.join('<br>').html_safe : content_tag(:span, SHOW_MSG)
      end
    end      
    f.actions
  end

  show do
    attributes_table do
      row :account
      row :region
      row :country
      row :state
      row :area
      row :country_code
      row :phone_number
      row :year
      row :make
      row :model
      row :regional_specs
      row :source_country
      row :pickup_port
      row :destination_country
      row :destination_port
      row :shipping_instruction
      row :status, include_blank: false
      row :cancelled_at
      row :shipping_status, include_blank: false
      row :picked_up_date
      row :onboarded_date
      row :arrived_date
      row :delivered_date
      row :final_destination_charge
      row :approved_by_admin
      row :vehicle_pickup
      row :onboard
      row :arrived
      row :destination_service
      row :shipment_noti
      row :onboard
      row :shipment
      row :arrived
      row :destination_service
      row :payment_confirmation_status, include_blank: false
      row :tracking_link
      row :payment_link
      row :estimated_time_of_departure
      row :estimated_time_of_arrival
      row :shipping_line
      row :container_number
      row :bl_number
      row :notes_for_admin
      row :invoice_amount

      
      row :destination_service, label: "Destination Service" do |vehicle_shipping|
        ServiceShipping.find_by(id: vehicle_shipping.service_shippings_id).title
      end

      row :shipping_invoice do |ad|
        link_to(ad.shipping_invoice.filename,url_for(ad.shipping_invoice), target: :_blank) if ad.shipping_invoice.present?
      end

      row :passport do |ad|
        link_to(ad.passport.filename,url_for(ad.passport), target: :_blank) if ad.passport.present?
      end

      row :payment_receipt do |ad|
        link_to(ad.payment_receipt.filename,url_for(ad.payment_receipt), target: :_blank) if ad.payment_receipt.present?
      end

      row :export_certificate do |ad|
        link_to(ad.export_certificate.filename,url_for(ad.export_certificate), target: :_blank) if ad.export_certificate.present?
      end

      row :conditional_report do |ad|
        link_to(ad.conditional_report.filename,url_for(ad.conditional_report), target: :_blank) if ad.conditional_report.present?
      end

      row :export_title do |ad|
        link_to(ad.export_title.filename,url_for(ad.export_title), target: :_blank) if ad.export_title.present?
      end

      row :car_images do |ad|
       ul do
        ad.car_images.each do |doc|
          li do 
            link_to(doc.filename,url_for(doc), target: :_blank)
          end
        end
       end
      end

      row :customer_payment_receipt do |ad|
       ul do
        ad.customer_payment_receipt.each do |doc|
          li do 
            link_to(doc.filename,url_for(doc), target: :_blank)
          end
        end
       end
      end

      row :other_documents do |ad|
       ul do
        ad.other_documents.each do |doc|
          li do 
            link_to(doc.filename,url_for(doc), target: :_blank)
          end
        end
       end
      end

      row :condition_pictures do |ad|
       ul do
        ad.condition_pictures.each do |doc|
          li do 
            link_to(doc.filename,url_for(doc), target: :_blank)
          end
        end
       end
      end

      row :loading_image do |ad|
       ul do
        ad.loading_image.each do |doc|
          li do 
            link_to(doc.filename,url_for(doc), target: :_blank)
          end
        end
       end
      end

      row :unloading_image do |ad|
       ul do
        ad.unloading_image.each do |doc|
          li do 
            link_to(doc.filename,url_for(doc), target: :_blank)
          end
        end
       end
      end

      row :created_at      
    end
  end
end