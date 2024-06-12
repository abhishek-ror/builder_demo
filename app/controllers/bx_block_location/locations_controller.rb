module BxBlockLocation
  class LocationsController < ApplicationController
    
    def region_list
      render json: {data: BxBlockAdmin::Region.select(:id, :name, :phone_no_digit).order(name: :asc).as_json(methods: ['image_url']), success: true}, status: :ok
    end

    def country_list
      if params[:region_id].present?
        render json: {data: BxBlockAdmin::Country.select(:id, :name, :country_code, :phone_no_digit).where(region_id: params[:region_id]).order(name: :asc).as_json(methods: ['image_url']), success: true}, status: :ok
      else
        render json: {message: 'Region Id is missing'}, status: 422
      end
    end

    def state_list
      if params[:country_id].present?
        render json: {data: BxBlockAdmin::State.select(:id, :name).where(country_id: params[:country_id]).order(name: :asc).as_json, success: true}, status: :ok
      else
        render json: {message: 'Country Id is missing'}, status: 422
      end
    end

    def area_list
      if params[:state_id].present?
        render json: {data: BxBlockAdmin::City.select(:id, :name).where(state_id: params[:state_id]).order(name: :asc).as_json, success: true}, status: :ok
      else
        render json: {message: 'State Id is missing'}, status: 422
      end
    end

  end
end
