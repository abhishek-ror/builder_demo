ActiveAdmin.register BxBlockVehicleShipping::VehicleShipping, as: "Shipment Orders" do
    menu false

  actions :all, :except => [:new]
  config.per_page = 10
  
  # :region, :country, :state, :area, :year, :make, :model, :regional_specs, :country_code, :phone_number, :full_phone_number, :source_country, :pickup_port, :destination_country, :destination_port, :account_id,
  permit_params :final_shipping_amount, :status, :payment_confirmation_status, :payment_receipt,
                shipment_attributes: [:id, :account_id, :estimated_time_of_departure, :estimated_time_of_arrival, :shipping_line, 
                  :container_number, :bl_number, :tracking_link, :status, :delivery_status, :payment_link, 
                  :delivery_proof, :destination_cost, :payment_mode, :payment_status, :loading_images => [], :unloading_images => []
                ]
  
  scope :all, default: true
  # scope("Open") { |scope| scope.where(status: 0) }
  scope("Pending") { |scope| scope.where(status: 0) }
  scope("New Order") { |scope| scope.where(status: 1) }
  scope("In transit") { |scope| scope.where(status: [2, 3, 4]) }
  scope("Delivered") { |scope| scope.where(status: 6) }
  scope("Cancelled") { |scope| scope.where(status: 5) }

  form do |f|
    f.inputs do
      f.input :region
      f.input :country
      f.input :state
      f.input :area
      f.input :country_code
      f.input :phone_number
      f.input :status, include_blank: false
      f.input :final_shipping_amount
      f.input :payment_confirmation_status
    end

    if f.object.payment_confirmation_status_submitted? || f.object.payment_confirmation_status_confirmed?
      f.inputs 'Shipment', :for => [:shipment, f.object.shipment || BxBlockShipment::Shipment.new] do |fi|
        # hint = image_tag(cd.object.image.url, style: "height: 10%; width: 10%") if cd.object.image.url()
        # cd.input :image, as: :file, :hint => hint
        # cd.input :item_type, as: :hidden, :input_html => { :value => 'reports' }
        fi.input :account_id, as: :hidden, input_html: {value: f.object.account_id}
        # fi.input :car_orders,label: 'Order Request Id',:as => :select, :collection => BxBlockOrdercreation3::CarOrder.all.collect {|order| [order.order_request_id,order.id] }
        fi.input :estimated_time_of_departure,as: :datepicker,
                        datepicker_options: {
                          min_date: 10.days.ago.to_date,
                          max_date: "+1W +5M"
                        }, input_html: {required: true} 
        fi.input :estimated_time_of_arrival,as: :datepicker,
                      datepicker_options: {
                        min_date: 10.days.ago.to_date,
                        max_date: "+1W +5M"
                      }, input_html: {required: true} 
        fi.input :shipping_line  
        fi.input :container_number
        fi.input :bl_number
        fi.input :tracking_link
        # fi.input :status, as: :select,include_blank: false, :collection => BxBlockShipment::Shipment.statuses.keys
        fi.input :delivery_status, as: :select, :collection => BxBlockShipment::Shipment.delivery_statuses.keys
        fi.input :destination_cost, as: :string
        fi.input :payment_mode, as: :select, :collection => BxBlockShipment::Shipment.payment_modes.keys
        fi.input :payment_status, as: :select, :collection => BxBlockShipment::Shipment.payment_statuses.keys
        fi.input :payment_link

        # fi.has_many :images, new_record: 'Attach Image', remove_record: 'Remove Image',heading: 'Loading Photos' do |cd|
        #   hint = image_tag(cd.object.image.url,class: 'my_index_image_size') if cd.object&.image&.url
        #   cd.input :image, as: :file, :hint => hint
        # end
        fi.input :loading_images, as: :file, input_html: {multiple: true}
        fi.input :unloading_images, as: :file, input_html: {multiple: true}
        fi.input :delivery_proof, as: :file, input_html: {multiple: true}
      end
    end
    
    f.actions
  end

  index do
    id_column
    column :order_request_id
    column :country
    column :state
    column :area
    column :phone_number
    column :final_shipping_amount
    column 'Order Status', :status
    column :payment_confirmation_status
    column :account
  
    actions
  end

  show do
    attributes_table do
      row :order_request_id, humanize_name: false
      row "Shipment" do 
        resource.shipment
      end
      row :account
      row :country
      row :state
      row :area
      row :country_code
      row :full_phone_number
      row :status
      row :created_at
      row :final_shipping_amount
      row :payment_confirmation_status
      
      row :car_images do |ad|
       ul do
        ad.car_images.each do |doc|
          li do 
            link_to(doc.filename,doc.blob.service_url, target: :_blank)
          end
        end
       end
      end

      row :payment_receipt do |ad|
        link_to(ad.payment_receipt.filename,ad.payment_receipt.blob.service_url, target: :_blank) if ad.payment_receipt.present?
      end
      
      row :export_certificate do |ad|
        link_to(ad.export_certificate.filename, ad.export_certificate.blob.service_url, target: :_blank) if ad.export_certificate.present?
      end

      row :conditional_report do |ad|
        link_to(ad.conditional_report.filename, ad.conditional_report.blob.service_url, target: :_blank) if ad.conditional_report.present?
      end

      row :passport do |ad|
        link_to(ad.passport.filename,ad.passport.blob.service_url, target: :_blank) if ad.passport.present?
      end

      row :other_documents do |ad|
       ul do
        ad.other_documents.each do |doc|
          li do 
            # link_to(doc.filename,rails_blob_path(doc,disposition: "attachment"))
            link_to(doc.filename,doc.blob.service_url, target: :_blank)
          end
        end
       end
      end
      
    end
  end

  filter :country
  filter :state
  filter :area

  
end
