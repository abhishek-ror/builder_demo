module BxBlockVehicleShippings
    class VehicleOrderSerializer
    include JSONAPI::Serializer
    attributes *[
     :order_request_id,
     :continent,
     :country,
     :state,
     :area,
     :country_code,
     :phone_number,
     :full_phone_number,
     :status,
     :status_updated_at,
     :notes,
     :instant_deposit_amount,
     :final_sale_amount,
     :vehicle_shipping_id,
     :payment_check,
     :created_at
    ]
    attributes :final_invoice do |object|
      object.final_invoice.attached? ? object.final_invoice.service_url : nil
    end
    attributes :payment_receipt do |object|
      # object.payment_receipt.attached? ? Rails.application.routes.url_helpers.rails_blob_path(object.photo, only_path: true) : "image not present"
      object.payment_receipt.attached? ? object.payment_receipt.service_url : nil
    end
    attributes :passport do |object|
      object.passport.attached? ? object.passport.service_url : nil
    end

    attributes :final_sale_amount do |object|
      object.final_sale_amount.present? ? ActiveSupport::NumberHelper.number_to_delimited(object.final_sale_amount.to_s.gsub("$",'').to_i) : nil
    end
    
    attributes :instant_deposit_amount do |object|
      object.instant_deposit_amount.present? ? ActiveSupport::NumberHelper.number_to_delimited(object.instant_deposit_amount.to_s.gsub("$",'').to_i) : nil
    end

    attributes :car_ad do |object|
      object.car_ad_id.present? ? true : false
    end

    attributes :cancel_time do |object|
      if object.status == "cancelled"
        object.status_updated_at
      else
        ""
      end
    end

    attributes :vehicle_status do |object|
       if ["ready to ship", "order shipped", "arrived at destination"].include? object.status
        "in transit"
       elsif ["inspection requested", "pre booked", "pending", "instant deposit", "final invoice payment", "sold"].include? object.status
        "interested"
       else
        object.status
      end
    end

    attributes :other_documents do |object|
      # get_other_documents object
      if object&.other_documents&.attached?
        object&.other_documents.map{|doc| doc.service_url}
      end
    end

    attributes :time_left do |object|
      if object.status_updated_at
        a = ((Time.parse(DateTime.now.to_s) - Time.parse(object.status_updated_at.to_s))/1.minute).divmod(60).map{|x| x.to_i}
        hours = (a[1] > 0) ? "#{48 -(1 + a[0])}:#{60 - a[1]}" :  "#{48 -a[1]}:00"
      else
        ""
      end
    end

    attributes :vehicle_details do |object, params|
      # get_order_details object
      if object&.vehicle_selling.present?
        BxBlockVehicleShippings::VehicleSellingSerializer.new(object&.vehicle_selling, params: {current_user_id: params[:current_user_id]}).serializable_hash[:data][:attributes]
      elsif object&.car_ad.present?
        if params[:get_purchased]
          BxBlockVehicleShippings::NewCarAdSerializer.new(object&.car_ad).serializable_hash[:data][:attributes]
        else
          BxBlockPosts::CarAdSerializer.new(object&.car_ad).serializable_hash[:data][:attributes]
        end
      end        
    end
end
end