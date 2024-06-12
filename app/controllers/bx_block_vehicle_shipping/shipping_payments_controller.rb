module BxBlockVehicleShipping
  class ShippingPaymentsController < ApplicationController
    before_action :validate_json_web_token
    before_action :set_current_user

    def payment
      @shipment = BxBlockVehicleShipping::VehicleShipping.find_by(id: params[:shipment_id])
      if @shipment.present? and @shipment.approved_by_admin == true
        stripe_card_id = BxBlockPayments::CreditCardService.new(@token.id, card_params).create_credit_card
        stripe_service = BxBlockPayments::StripeIntegrationService.new(@token.id)
        payment_response = stripe_service.stripe_payment_intent(payment_attributes.merge(stripe_card_id: stripe_card_id))
        p 
        if payment_response&.id.present?
          @shipment.update!(transaction_id: payment_response&.id, amount_paid: payment_response&.amount,
                            transaction_date: Time.now, payment_status: 'success')
          render json: { success: true, message: 'payment process successful', payment: @shipment.as_json(only: %i[id transaction_id payment_status transaction_date amount_paid]) },
                 status: 200
        else
          render json: { success: false, message: 'Unable to initiate payment process' }, status: 422
        end
      else
        render json: { success: false, message: 'Unable to initiate payment process due to the invalid shipment id/Not Approved by admin yet' },
               status: 404
      end
    end


    private

    def set_current_user
      @current_user ||= AccountBlock::Account.find_by(id: @token.id)
      return render json: { errors: 'Account Not Found' }, status: :not_found if @current_user.blank?
    end

    def card_params
      params.require(:card).permit(:number, :month, :year, :cvc)
    end

    def payment_attributes
      {
        amount: @shipment.final_destination_charge,
        currency: 'usd',
        description: 'VehicleSelling-Price',
        metadata: { type: 'BxBlockVehicleShipping::VehicleOrder', id: @shipment.id }
      }
    end
  end
end
