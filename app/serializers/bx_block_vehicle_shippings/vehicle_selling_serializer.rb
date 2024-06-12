module BxBlockVehicleShippings
    class VehicleSellingSerializer
      include JSONAPI::Serializer
      attributes *[
        :id,
        :region_id,
        :country_id,
        :state_id,
        :city_id,
        :trim_id,
        :account_id,
        :year,
        :make,
        :regional_spec,
        :kms,
        :body_color,
        :body_type,
        :seller_type,
        :engine_type,
        :steering_side,
        :model,
        :badges,
        :features,
        :no_of_doors,
        :transmission,
        :price,
        :warranty,
        :no_of_cylinder,
        :horse_power,
        :contact_number,
        :about_car,
        :is_inspected,
        :approved_by_admin,
        :created_at,
        :updated_at
      ] 

      attribute :country do |object|
          object.country.name.as_json
      end

      attribute :is_favourite do |object, attributes|
        attributes[:current_user_id] ? object.is_favourite?(attributes[:current_user_id]) : false
      end

      attribute :favourite_id do |object, attributes|
       object.get_favourite_id(attributes[:current_user_id]) if attributes[:current_user_id]
      end

      attribute :images do |object|
        object&.images.as_json(only: [:id, :image])
      end

      attributes :buy_check do |object, attributes|
        attributes[:current_user_id] ? (object.vehicle_orders.where(account_id: attributes[:current_user_id]).present?) : false
      end

      attributes :price do |object|
        object.price.present? ? ActiveSupport::NumberHelper.number_to_delimited(object.price.to_s.gsub("$",'').to_i) : nil
      end

      attributes :admin do |object| 
        if object.admin_user.present?
          object.admin_user.as_json
        else
        AdminUser.last.as_json
        end
      end 
      
    end
end
  