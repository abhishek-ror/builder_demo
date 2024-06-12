class ServiceShippingController < ApplicationController
include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token
    before_action :current_user

    def index
      # shipments = BxBlockVehicleShipping::VehicleShipping.find_by_id(account_id: current_user.id) 	
      destionation_services = ServiceShipping.all
      render json: ServiceShippingSerializer.new(destionation_services).serializable_hash, status: :ok
    end
end
