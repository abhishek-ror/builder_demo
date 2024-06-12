ActiveAdmin.register BxBlockOrdercreation3::CarOrder, as: "OrderRequest" do
    menu false

  actions :all, :except => [:new]
  config.per_page = 10
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :continent, :country, :state, :area, :country_code, :phone_number, :full_phone_number, 
                :account_id, :car_ad_id, :status, :final_sale_amount, :final_invoice, :payment_receipt, 
                :final_invoice_payment_status, :passport, :other_documents, :instant_deposit_amount, :instant_deposit_status,
                shipment_attributes: [:id, :account_id, :estimated_time_of_departure, :estimated_time_of_arrival, :shipping_line, 
                  :container_number, :bl_number, :tracking_link, :status, :delivery_status, :payment_link, 
                  :delivery_proof, :destination_cost, :payment_mode, :payment_status, :loading_images => [], :unloading_images => []
                ]
  #
  # or
  #
  # permit_params do
  #   permitted = [:continent, :country, :state, :area, :country_code, :phone_number, :full_phone_number, :account_id, :car_ad_id, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  scope :all, default: true
  # scope("Open") { |scope| scope.where(status: 0) }
  scope("Pending") { |scope| scope.where(status: 1) }
  scope("Pre booked") { |scope| scope.where(status: [4, 11]) }
  scope("Inspection requested") { |scope| scope.where(status: 3) }
  scope("New Order") { |scope| scope.where(status: 12) }
  scope("In transit") { |scope| scope.where(status: [6,7,8]) }
  scope("Sold") { |scope| scope.where(status: 5) }
  scope("Delivered") { |scope| scope.where(status: 9) }
  scope("Cancelled") { |scope| scope.where(status: 2) }

  form do |f|
    f.inputs do
      f.input :continent
      f.input :country
      f.input :state
      f.input :area
      f.input :country_code
      f.input :phone_number
      f.input :full_phone_number
      f.input :status, include_blank: false
      f.input :instant_deposit_amount
      f.input :instant_deposit_status, as: :select, collection: BxBlockOrdercreation3::CarOrder.instant_deposit_statuses.keys
      f.input :final_sale_amount
      f.input :final_invoice_payment_status, as: :select, collection: BxBlockOrdercreation3::CarOrder.final_invoice_payment_statuses.keys
      f.input :final_invoice, as: :file
      f.input :payment_receipt, as: :file
      f.input :passport, as: :file
      f.input :other_documents, as: :file, input_html: {multiple: true}
    end

    if f.object.final_invoice_payment_status_submitted? || f.object.final_invoice_payment_status_confirmed?
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
    column :instant_deposit_amount
    column :instant_deposit_status
    column :final_sale_amount
    column :final_invoice_payment_status
    column 'Order Status', :status
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
      row :instant_deposit_status
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
            # link_to(doc.filename,rails_blob_path(doc,disposition: "attachment"))
            link_to(doc.filename,doc.blob.service_url, target: :_blank)
          end
        end
       end
      end
      
    end
  end

  filter :continent
  filter :country
  filter :state
  filter :area

  
end
