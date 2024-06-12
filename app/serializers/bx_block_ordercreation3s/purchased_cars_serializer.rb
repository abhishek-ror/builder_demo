module BxBlockOrdercreation3s
  class PurchasedCarsSerializer
    include JSONAPI::Serializer
    
    attributes *[
     :order_request_id,
     :status,
     :created_at,
     :cancelled_at,
     :id
    ]

    attribute :car_details do |object|
      if object.car_ad.present?
        {name: object.car_ad&.model&.name, images: object&.car_ad&.images.as_json(only: [:image])}
      end

      if object&.vehicle_inspection.present?
        {name: object.vehicle_inspection&.model&.name, images: object&.vehicle_inspection&.images.as_json(only: [:image])}
      end
    end 
  end

end
