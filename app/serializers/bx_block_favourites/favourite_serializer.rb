module BxBlockFavourites
  class FavouriteSerializer < BuilderBase::BaseSerializer
    attributes *[
      :favouriteable_id,
      :favouriteable_type,
      :favourite_by_id,
      :created_at,
      :updated_at,
    ]
    attribute :images do |object|
      if object.favouriteable_type == "BxBlockVehicleShipping::VehicleSelling"
        BxBlockVehicleShipping::VehicleSelling.find_by(id: object.favouriteable_id)&.images.each do |obj|
          obj&.image_url
        end
      else
        BxBlockAdmin::CarAd.find_by(id: object.favouriteable_id)&.images.each do |obj|
          obj&.image_url
        end
      end
    end

    attribute :price do |object|
      if object.favouriteable_type == "BxBlockVehicleShipping::VehicleSelling"
        BxBlockVehicleShipping::VehicleSelling.find_by(id: object.favouriteable_id)&.price
      else
        BxBlockAdmin::CarAd.find_by(id: object.favouriteable_id)&.price
      end
    end

    attribute :car_name do |object|
      if object.favouriteable_type == "BxBlockVehicleShipping::VehicleSelling"
        BxBlockVehicleShipping::VehicleSelling.find_by(id: object.favouriteable_id)&.model
      else
        BxBlockAdmin::CarAd.find_by(id: object.favouriteable_id)&.trim&.name
      end
    end
  end
end
