class BxBlockContentManagement::CompanySerializer
  include JSONAPI::Serializer
  attributes :id, :name, :logo
  
  attribute :logo do |object|
    object.logo_url
  end

  attribute :brand_count do |object|
    BxBlockAdmin::CarAd.where(status: 'posted').joins(trim: :model).where('models.company_id = ?', object.id).count + BxBlockVehicleShipping::VehicleSelling.where(tracking_status: 'Posted').joins(trim: :model).where('models.company_id = ?', object.id).count
  end

end
