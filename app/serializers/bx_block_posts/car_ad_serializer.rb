class BxBlockPosts::CarAdSerializer < BuilderBase::BaseSerializer
  attributes :id, :city, :trim, :body_color, :fuel_type, :model, :make_year, :no_of_doors, :no_of_cylinder, :horse_power, :warranty, :battery_capacity, :more_details, :steering_side, :body_color, :transmission, :price, :status, :order_id, :ad_type, :images, :mobile_number, :kms, :fuel_type_description, :created_at

  attribute :body_color do |object|
    object.colors&.last&.name
  end

  attribute :city do |object|
    object.city.as_json
  end

  attribute :is_favourite do |object, attributes|
    attributes[:current_user_id] ? object.is_favourite?(attributes[:current_user_id]) : false
  end

  attribute :buy_check do |object, attributes|
     attributes[:current_user_id] ? (object.vehicle_orders.where(account_id: attributes[:current_user_id]).present?) : false
  end

  attribute :favourite_id do |object, attributes|
    object.get_favourite_id(attributes[:current_user_id]) if attributes[:current_user_id]
  end

  attribute :body_type do |object|
    object.body_type || object.model.body_type
  end

  attribute :car_type do |object|
    object.car_type&.humanize
  end

  attribute :model do |object|
    object&.model.as_json
  end

  attribute :trim do |object|
    object&.trim.as_json
  end

  attribute :images do |object|
    object&.images.as_json
  end

  attribute :regional_specs do |object|
    object&.regional_specs.as_json
  end

  attributes :price do |object|
      object.price.present? ? ActiveSupport::NumberHelper.number_to_delimited(object.price.to_s.gsub("$",'').to_i) : nil
  end

  attribute :colors do |object|
    object&.colors.as_json
  end

  attribute :features do |object|
    object&.features.as_json
  end

  attribute :extras do |object|
    object&.extras.as_json
  end

  attribute :badges do |object|
    object&.badges.as_json
  end

  attribute :car_engine_types do |object|
    object&.car_engine_types.as_json
  end

  attribute :seller_types do |object|
    object&.seller_types.as_json
  end

  attribute :inspected do |object|
    object&.vehicle_inspection.present? && object&.vehicle_inspection.completed?
  end

  attribute :sold_at do |object|
    if object.status == "sold"
      object.updated_at
    else
      ""
    end
  end

  attribute :is_inspected do |object|
    BxBlockAdmin::VehicleInspection.where.not(status: "rejected").find_by(car_ad_id: object.id).present? ? true : false
  end

  attribute :created_at do |object|
    object.created_at.strftime("%Y-%m-%dT%H:%M:%S.999Z")
  end

  attributes :account do |object|
    AccountBlock::AccountSerializer.new(object.account).serializable_hash[:data][:attributes]
  end

  attributes :admin do |object| 
    if object.admin_user.present?
      object.admin_user.as_json
    else
    AdminUser.last.as_json
    end
  end 
end