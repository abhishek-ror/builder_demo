module BxBlockServices
    class ServicesController < ApplicationController
      include BuilderJsonWebToken::JsonWebTokenValidation

      def index
        services = BxBlockServices::Service.all
        if services.present?
            render json: {services: BxBlockServices::ServiceSerializer.new(services)}
        else
            render json: {Message: "No Services available"}
        end
      end
    end
end  