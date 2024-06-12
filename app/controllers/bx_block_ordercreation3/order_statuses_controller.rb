module BxBlockOrdercreation3
	class OrderStatusesController < ApplicationController
    	include BuilderJsonWebToken::JsonWebTokenValidation
    	before_action :validate_json_web_token
		before_action :current_user

		def order_status
			if params[:status] == "in_transit"
				get_lists = BxBlockOrdercreation3::CarOrder.where(status: [6,7,8],account_id: current_user.id)	
			elsif params[:status] == "interested"
				get_lists = BxBlockOrdercreation3::CarOrder.where(status: [3,4],account_id: current_user.id)
			elsif params[:status] == "delivered"
				get_lists = BxBlockOrdercreation3::CarOrder.where(status: 9,account_id: current_user.id)	
			elsif params[:status] == "cancelled"
				get_lists = BxBlockOrdercreation3::CarOrder.where(status: 2,account_id: current_user.id)
			else
				return render json: {error: "Invalid Parameters"},status: :unprocessable_entity
			end
			return render json: {data: BxBlockOrdercreation3s::CarOrderSerializer.new(get_lists)} if get_lists.present?
			return render json: {data: "orders not available"} if get_lists.blank? 
		end

		# def shipment_status
		# 	if params[:status] == "ongoing"
		# 		get_lists = BxBlockShipment::Shipment.where(status: [1,2,3],account_id: current_user.id)	
		# 	elsif params[:status] == "completed"
		# 		get_lists = BxBlockShipment::Shipment.where(status: 5,account_id: current_user.id)
			
		# 	elsif params[:status] == "cancelled"
		# 		get_lists = BxBlockShipment::Shipment.where(status: 4,account_id: current_user.id)
		# 	else
		# 		return render json: {error: "Invalid Parameters"},status: :unprocessable_entity
		# 	end
		# 	return render json: {data: BxBlockShipments::ShipmentSerializer.new(get_lists)} if get_lists.present?
		# 	return render json: {data: "shipment not available"} if get_lists.blank? 
		# end

	end
end
