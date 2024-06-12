ActiveAdmin.register BxBlockShipment::Shipment, as: 'Order Shipments' do
  menu false

  permit_params :estimated_time_of_departure, :estimated_time_of_arrival, :shipping_line, :container_number, 
  :bl_number, :tracking_link, :status, :payment_link, :delivery_status, :car_order_id, :account_id, 
  :delivery_proof, :payment_mode, :payment_status, :destination_cost,
  :loading_images => [], :unloading_images => []

  actions :all, :except => [:new, :destroy]

  form do |f|
    f.inputs do
      f.input :account_id, :as => :select, :collection => AccountBlock::Account.all.collect {|account| [account.full_name || account.company_name,account.id] }
      f.input :car_order, label: 'Order',:as => :select, :collection => BxBlockOrdercreation3::CarOrder.all.collect {|order| [order.order_request_id,order.id] }
      f.input :estimated_time_of_departure,as: :datepicker,
                      datepicker_options: {
                        min_date: 10.days.ago.to_date,
                        max_date: "+1W +5M"
                      }
      f.input :estimated_time_of_arrival,as: :datepicker,
                    datepicker_options: {
                      min_date: 10.days.ago.to_date,
                      max_date: "+1W +5M"
                    }
      f.input :shipping_line  
      f.input :container_number
      f.input :bl_number
      f.input :tracking_link
      # f.input :status, include_blank: false
      f.input :delivery_status, as: :select, :collection => BxBlockShipment::Shipment.delivery_statuses.keys
      f.input :destination_cost, as: :string
      f.input :payment_mode, as: :select, :collection => BxBlockShipment::Shipment.payment_modes.keys
      f.input :payment_status, as: :select, :collection => BxBlockShipment::Shipment.payment_statuses.keys
      f.input :payment_link
      f.input :loading_images, as: :file, input_html: {multiple: true}
      f.input :unloading_images, as: :file, input_html: {multiple: true}
      f.input :delivery_proof, as: :file, input_html: {multiple: true}
    end      
    f.actions
  end

  index download_links: [:csv] do
    selectable_column
    id_column
    column :car_order do |ord|
      # order = BxBlockOrdercreation3::CarOrder.find(ord.car_orders_id)
      link_to ord&.car_order&.order_request_id, admin_order_request_path(ord.car_order_id)
    end 
    column :account_id do |account|
      account_details = AccountBlock::Account.find(account.account_id)
      link_to account_details.full_name || account_details.company_name, admin_account_path(account.account_id)
    end
    column :estimated_time_of_departure
    column :estimated_time_of_arrival
    column :shipping_line
    column :container_number
    column :tracking_link
    column :status
    column :delivery_status
    column :destination_cost
    column :payment_link
    column :review

    actions
  end

  show do
    attributes_table do
      row :car_order do |ord|
        # order = BxBlockOrdercreation3::CarOrder.find(ord.car_orders_id)
        link_to ord.car_order.order_request_id, admin_order_request_path(ord.car_order_id)
      end 
      row :account_id do |account|
        account_details = AccountBlock::Account.find(account.account_id)
        link_to account_details.full_name || account_details.company_name, admin_account_path(account.account_id)
      end
      row :estimated_time_of_departure
      row :estimated_time_of_arrival
      row :shipping_line
      row :container_number
      row :bl_number
      row :status
      row :tracking_link
      row :delivery_status
      row :destination_cost
      row :payment_mode
      row :payment_status
      row :payment_link

      row 'Loading Photos' do |_shipment|
        if _shipment.loading_images.attached?
          ul do
            _shipment.loading_images.each do |img|
              li do
                link_to(img.filename, img.blob.service_url, target: :_blank)
              end
            end
          end
        end
      end
      
      row :payment_receipt do |pr|
        link_to(pr.payment_receipt.filename,pr.payment_receipt.blob.service_url) if pr.payment_receipt.attached?       
      end

      row 'Unloading Photos' do |_shipment|
        if _shipment.unloading_images.attached?
          ul do
            _shipment.unloading_images.each do |img|
              li do
                link_to(img.filename, img.blob.service_url, target: :_blank)
              end
            end
          end
        end
      end
      row :review     
    end
  end
  filter :bl_number
  filter :status
  filter :shipping_line
  filter :container_number   
end