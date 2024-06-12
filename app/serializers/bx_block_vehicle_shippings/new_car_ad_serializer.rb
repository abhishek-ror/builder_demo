module BxBlockVehicleShippings
    class NewCarAdSerializer
      include JSONAPI::Serializer
      attributes *[
        :id,
        :city_id,
        :trim_id,
        :account_id,
        :kms,
        :body_type,
        :steering_side,
        :no_of_doors,
        :transmission,
        :price,
        :warranty,
        :no_of_cylinder,
        :horse_power,
        :created_at,
        :updated_at
      ] 

      attribute :body_color do |object|
        object.colors&.last&.name
      end

      attribute :regional_spec do |object|
        object&.regional_specs&.last&.name
      end

      attribute :year do |object|
          object.make_year.as_json
      end

      attribute :make do |object|
          object.make_year.as_json
      end

      attribute :model do |object|
          object.trim.model.name.as_json
      end

      attributes :price do |object|
        object.price.present? ? ActiveSupport::NumberHelper.number_to_delimited(object.price.to_s.gsub("$",'').to_i) : nil
      end

      attribute :country_id do |object|
        object.city.state.country.id.as_json
      end

      attribute :region_id do |object|
        object.city.state.country.region.id.as_json
      end

      attribute :country do |object|
          object.city.state.country.name.as_json
      end

      attribute :state_id do |object|
          object.city.state.id.as_json
      end

      attribute :engine_type do |object|
          object.fuel_type.as_json
      end

      attribute :badges do |object|
          ""
      end

      attribute :features do |object|
          ""
      end

      attribute :created_at do |object|
        object.created_at.strftime("%Y-%m-%dT%H:%M:%S.999Z")
      end

      attribute :about_car do |object|
          object.more_details.as_json
      end

      attribute :contact_number do |object|
          object.mobile_number.as_json
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

      attributes :admin do |object| 
        if object.admin_user.present?
          object.admin_user.as_json
        else
        AdminUser.last.as_json
        end
      end 
      
      attribute :is_inspected do |object|
        BxBlockAdmin::VehicleInspection.find_by(car_ad_id: object.id).present? ? true : false
      end

    end
end
  