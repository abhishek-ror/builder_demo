module BxBlockShipment
	class ShipmentsController < ApplicationController
		include BuilderJsonWebToken::JsonWebTokenValidation
    include ActiveStorage::SetCurrent

    before_action :validate_json_web_token
    before_action :load_shipment, only: [:get_shipping_detail, :upload_documents]
    before_action :set_current_user
  	
    def get_shipping_detail
 			render json: { data: BxBlockShipments::ShipmentSerializer.new(@shipment).serializable_hash }
    end

    def upload_documents
      payment_status = @shipment.payment_status_confirmed? ? 'confirmed' : 'submitted'

    	if @shipment.update(document_params.merge(payment_status: payment_status))
        render json: {message: "Document uploaded successfully..",
              data: BxBlockShipments::ShipmentSerializer.new(@shipment).serializable_hash }
      else
        render json: {error: "Unable to upload documents.", status: 422}, status: :unprocessable_entity
      end
    end

    def review
      review = BxBlockShipment::UserReview.find_by(account_id: @current_user.id, shipment_id: review_params[:shipment_id])
      if review.present?
        unless review.update(review_params)
          render json: {status: 422, message: 'Something went wrong'}, status: 422
        end
      else
        review = BxBlockShipment::UserReview.new(review_params)
        review.account_id = @current_user.id
        unless review.save
          render json: {status: 422, message: review.errors.full_messages.join(',')}, status: 422
        end
      end
    end

    private

    def load_shipment
      @shipment = BxBlockShipment::Shipment.find_by(id: params[:id])
      return render json: {error: "Shipment not found", status: 422}, status: :unprocessable_entity if @shipment.blank?
    end

    def set_current_user
      @current_user ||= AccountBlock::Account.find_by(id: @token.id)
      return render json: {errors: 'Account Not Found'}, :status => :not_found if @current_user.blank?
    end

    def document_params
      params.permit(:payment_receipt, :passport, :other_documents)
    end

    def review_params
      params.permit(:shipment_id, :review, :quick_response_rating, :detailed_service_rating, :supportive_rating)
    end
	end
end
