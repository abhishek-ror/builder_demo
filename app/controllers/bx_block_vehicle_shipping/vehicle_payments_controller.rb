module BxBlockVehicleShipping
  class VehiclePaymentsController < ApplicationController
   before_action :validate_json_web_token
   before_action :set_current_user
   # before_action :load_car_order, only: [:payment]

    def payment
   	 # @order_check =  @car_order.payments.present? ? @car_order.payments.first.status : 'nil'
     # return render json: {success: false, message: 'Payment has already done.This car has been already sold'}, status: 422 if @order_check == "success"
     @car_order = BxBlockVehicleShipping::VehicleOrder.find_by(account_id: @current_user.id, order_request_id: params[:order_request_id])
     if @car_order.present? 
  	 stripe_card_id =  BxBlockPayments::CreditCardService.new(@token.id, card_params).create_credit_card       
  	 stripe_service = BxBlockPayments::StripeIntegrationService.new(@token.id)
     payment_response = stripe_service.stripe_payment_intent(payment_attributes.merge(stripe_card_id: stripe_card_id))
      if payment_response&.id.present?
        # BxBlockPushNotifications::PushNotification.where(account_id: @current_user.id, notification_type_id: params[:order_request_id]).destroy_all
        # BxBlockPushNotifications::PushNotification.create(account_id: @car_order.account_id, remarks: "Your final invoice has been generated. Tap to view.", notify_type: "Push Notification", push_notificable_id: @car_order.account_id, push_notificable_type: "AccountBlock::Account", is_read: false, logo: @base_url, notification_type: "vehicle payment invoice", notification_type_id: @car_order.order_request_id)
        # vehicle_shipment = BxBlockVehicleShipping::VehicleShipping.create
        if @car_order.vehicle_selling_id.present?          
          @payment = VehiclePayment.create!(account_id:@token.id,transaction_id:payment_response&.id,status:"success",amount:payment_response&.amount,date:Time.now,vehicle_selling_id:@car_order.vehicle_selling_id)
        else
          @payment = VehiclePayment.create!(account_id:@token.id,transaction_id:payment_response&.id,status:"success",amount:payment_response&.amount,date:Time.now,car_ad_id:@car_order.car_ad_id)
        end
          
        @car_order.update!(status: 11, payment_check: true)
        render json: {success: true, message: 'payment process successful', payment:@payment.as_json}, status: 200
      else

      	render json: {success: false, message: 'Unable to initiate payment process'}, status: 422
      end
    else
      render json: {success: false, message: 'Unable to initiate payment process due to the invalid car id'}, status: 404
    end
    end

    private
    # def load_car_order
    # 	@car_order = BxBlockVehicleShipping::VehicleSelling.find_by_id(params[:vehicle_id])
    # 	return render json: {status: 422, message: 'Invalid vehicle details'}, status: 422 if @car_order.blank?
    # end
    def set_current_user
      @current_user ||= AccountBlock::Account.find_by(id: @token.id)
      return render json: {errors: 'Account Not Found'}, :status => :not_found if @current_user.blank?
    end

    def card_params
     params.require(:card).permit(:number, :month, :year, :cvc)
    end

    def payment_attributes
      {
       amount: @car_order.instant_deposit_amount,
       currency: 'usd',
       description: 'VehicleSelling-Price',
       metadata: {type: 'BxBlockVehicleShipping::VehicleOrder', id: @car_order.id},
      }
    end
  end
end