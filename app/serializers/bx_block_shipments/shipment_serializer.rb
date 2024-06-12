module BxBlockShipments
  class ShipmentSerializer
    include JSONAPI::Serializer
    attributes *[
      :id,
      :estimated_time_of_departure,
      :estimated_time_of_arrival,
      :shipping_line,
      :container_number,
      :bl_number,
      :tracking_link,
      :status,
      :delivery_status,
      :review,
      :destination_cost,
      :payment_mode,
      :payment_status,
      :payment_link,

    ]

    attributes :loading_photos do |object|
      if object&.loading_images.attached?
        object.loading_images.map{|doc| doc.service_url}
      end
    end

    attributes :unloading_photos do |object|
      if object&.unloading_images.attached?
        object.unloading_images.map{|doc| doc.service_url}
      end
    end

    attributes :payment_receipt do |object|
      object.payment_receipt.attached? ? object.payment_receipt.service_url : nil
    end

    attributes :passport do |object|
      object.passport.attached? ? object.passport.service_url : nil
    end

    attributes :other_documents do |object|
      if object&.other_documents&.attached?
        object&.other_documents.map{|doc| doc.service_url}
      end
    end

    attributes :delivery_proof do |object|
      if object&.delivery_proof&.attached?
        object&.delivery_proof.map{|doc| doc.service_url}
      end
    end
    
    attributes :car_orders_details do |object, params|
      # order = BxBlockOrdercreation3::CarOrder.find(object.car_orders_id)
      unless params[:hide_order_dtl]
        BxBlockOrdercreation3s::CarOrderSerializer.new(object.car_order).serializable_hash[:data][:attributes] if object.car_order.present?
      end
    end

    attributes :vehicle_shipping_details do |object, params|
      unless params[:hide_vehicle_shipping_dtl]
        BxBlockVehicleShippings::VehicleShippingSerializer.new(object.vehicle_shipping).serializable_hash[:data][:attributes] if object.vehicle_shipping.present?
      end
    end

  end
end
