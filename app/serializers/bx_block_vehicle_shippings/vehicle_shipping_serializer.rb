module BxBlockVehicleShippings
  class VehicleShippingSerializer
    include JSONAPI::Serializer
    attributes *[
      :id,
      :region,
      :country,
      :state,
      :area,
      :year,
      :make,
      :model,
      :regional_specs,
      :country_code,
      :phone_number,
      :full_phone_number,
      :source_country,
      :pickup_port,
      :destination_country,
      :destination_port,
      :shipping_instruction,
      :status,
      :cancelled_at,
      :shipping_status,
      :picked_up_date,
      :onboarded_date,
      :arrived_date,
      :delivered_date,
      :tracking_number,
      :created_at,
      :order_request_id,
      :final_shipping_amount,
      :payment_confirmation_status,
      :final_destination_charge,
      :notes_for_admin,
      :other_charge,
      :final_shipping_amount,
      :payment_confirmation_status,
      :estimated_time_of_departure,
      :estimated_time_of_arrival,
      :shipping_line,
      :container_number,
      :bl_number,
      :tracking_link,
      :delivery_status,
      :payment_link,
      :review,
      :order_request_id,
      :order_confirmed_at,
      :order_shipped_at,
      :destination_reached_at,
      :delivered_at,
      :final_destination_charge,
      :transaction_id,
      :transaction_date,
      :payment_type,
      :service_shippings_id] 
    

    attributes :car_images do |object|
      if object.car_images.attached?
        object.car_images.map { |image|
          {
              id: image.id,
              url: Rails.env.development? ? (Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)) : image&.service_url
          }
        }
      end
    end

    attributes :shipment_details do |object|
      if object&.shipment.present?
        BxBlockShipments::ShipmentSerializer.new(object&.shipment, {params: {hide_vehicle_shipping_dtl: true}}).serializable_hash[:data][:attributes]
      end
    end

    attributes :shipping_invoice do |object|
      if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(object.shipping_invoice, only_path: true) if object.shipping_invoice.attached?
      else
        object.shipping_invoice.attached? ? object.shipping_invoice.service_url : nil 
      end
    end

    attributes :export_certificate do |object|
      if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(object.export_certificate, only_path: true) if object.export_certificate.attached?
      else
        object.export_certificate.attached? ? object.export_certificate&.service_url : nil
      end
    end
    attributes :vehicle_order_reqest_id do |object|
      if object.vehicle_order.present?
        object.vehicle_order.order_request_id
      else
        ""
      end
    end


    attributes :passport do |object|
      if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(object.passport, only_path: true) if object.passport.attached?
      else
        object.passport.attached? ? object.passport.service_url : nil
      end
    end

    attributes :export_title do |object|
      if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(object.export_title, only_path: true) if object.export_title.attached?
      else
        object.export_title.attached? ? object.export_title.service_url : nil
      end
    end
    

    attributes :other_documents do |object|
      if object.other_documents.attached?
        object.other_documents.map { |documents|
          {
              id: documents.id,
              url: Rails.env.development? ? (Rails.application.routes.url_helpers.rails_blob_url(documents, only_path: true)) : documents&.service_url
          }
        }
      end
    end

  attributes :check_for_continue do |object|
      if object&.other_documents&.attached?
        true
      else
        false
      end
    end
    # attributes :payment_receipt do |object|
    #   if object.payment_receipt.attached?
    #     object.payment_receipt.map { |documents|
    #       {
    #           id: documents.id,
    #           url: Rails.env.development? ? (Rails.application.routes.url_helpers.rails_blob_url(documents, only_path: true)) : documents&.service_url
    #       }
    #     }
    #   end
    # end

    attributes :condition_pictures do |object|
      if object.condition_pictures.attached?
        object.condition_pictures.map { |pictures|
          {
              id: pictures.id,
              url: Rails.env.development? ? (Rails.application.routes.url_helpers.rails_blob_url(pictures, only_path: true)) : pictures&.service_url
          }
        }
      end
    end

    attributes :conditional_report do |object|
      if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(object.conditional_report, only_path: true) if object.conditional_report.attached?
      else
        object.conditional_report.attached? ? object.conditional_report.service_url : nil
      end  
    end

    attributes :payment_receipt do |object|
      if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(object.payment_receipt, only_path: true) if object.payment_receipt.attached?
      else
        object.payment_receipt.attached? ? object.payment_receipt.service_url : nil
      end
    end

    attributes :loading_image do |object|
      if object.loading_image.attached?
        object.loading_image.map { |documents|
          {
              id: documents.id,
              url: Rails.env.development? ? (Rails.application.routes.url_helpers.rails_blob_url(documents, only_path: true)) : documents&.service_url
          }
        }
      end
    end

    attributes :unloading_image do |object|
      if object.unloading_image.attached?
        object.unloading_image.map { |documents|
          {
              id: documents.id,
              url: Rails.env.development? ? (Rails.application.routes.url_helpers.rails_blob_url(documents, only_path: true)) : documents&.service_url
          }
        }
      end
    end
    
    attributes :account do |object|
      AccountBlock::AccountSerializer.new(object&.account)&.serializable_hash[:data][:attributes] if object.account.present?
    end

    attributes :show_tracking do |object|
      if object.estimated_time_of_departure.present? or object.estimated_time_of_arrival.present? or object.shipping_line.present? or object.container_number.present? or object.bl_number.present? or object.tracking_link.present?
        true
      else
        false
      end
    end


    attributes :vehicle_details do |object|
      if object.vehicle_order.present?
      # get_order_details object
        if object.vehicle_order.vehicle_selling.present?
          BxBlockVehicleShippings::VehicleSellingSerializer.new(object&.vehicle_order.vehicle_selling).serializable_hash[:data][:attributes]
        elsif object&.vehicle_order.car_ad.present?
          BxBlockPosts::CarAdSerializer.new(object&.vehicle_order.car_ad).serializable_hash[:data][:attributes]
        end
      else
        []
      end          
    end

  end
end