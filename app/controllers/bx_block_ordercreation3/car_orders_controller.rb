module BxBlockOrdercreation3
	class CarOrdersController < ApplicationController
  	include BuilderJsonWebToken::JsonWebTokenValidation

  	before_action :validate_json_web_token
  	before_action :set_current_user
  	before_action :load_car_order, only: [:payment, :get_order, :request_inspection, :buy_car]
  	include ActiveStorage::SetCurrent

  	def create
  		get_buyer_params = create_params
    	if get_buyer_params["country_code"].present? && get_buyer_params["phone_number"].present?
    		get_buyer_params[:full_phone_number] = get_buyer_params["country_code"] + get_buyer_params["phone_number"]
    	end
      # get_buyer_params[:car_ad_id] = 1 if create_params[:car_ad_id].blank?
    	phone_validator = valid_phone_number(get_buyer_params[:full_phone_number])
    	return render json: {error: "Phone Number Invalid"}, status: 422 if phone_validator.present?
			
    	buy_request = BxBlockOrdercreation3::CarOrder.new(get_buyer_params.merge({account_id: @current_user.id, status: 1}))
    	if buy_request.save
    		# buy_request.update(status: 1)
				render json: BxBlockOrdercreation3s::CarOrderSerializer.new(buy_request, meta: {
                message: "Your details have been submitted to the admin,they will contact you shortly"
              }).serializable_hash, status: :ok
    	else
    		render json: {
              errors: format_activerecord_errors(buy_request.errors)
            }, status: :unprocessable_entity
    	end
  	end

  	def get_order
  		if params[:order_request_id].present?
  			render json: {status: 200, data: BxBlockOrdercreation3s::CarOrderSerializer.new(@car_order).serializable_hash}, status: 200
  		else
				render json: {status: 422, message: 'Required inputs missing'}, status: 422
  		end
  	end

  	def get_all_buy_request	
  		orders = BxBlockOrdercreation3::CarOrder.where(account_id: @current_user.id)
  		if params[:status].present?
  			orders = orders.where(status: params[:status])
  		end

  		render json: {status: 200, data: BxBlockOrdercreation3s::PurchasedCarsSerializer.new(orders).serializable_hash }, status: 200
  	end

  	def upload_document    
	    order = BxBlockOrdercreation3::CarOrder.find_by(account_id: @current_user.id, order_request_id: document_params[:order_request_id])
	    if order.present?
				order.update(document_params.merge(final_invoice_payment_status: 'submitted'))
				render json: {
					data: BxBlockOrdercreation3s::CarOrderSerializer.new(order).serializable_hash,
					status: 200,
					message: "Documents Submitted Successfully You will Receive Notification Regarding Shipment details.."
				}, status: 200
			else
				render json: { error: "Order Not Found", status: 404 }		
			end
  	end


  	def get_documents
  		documents = BxBlockOrdercreation3::CarOrder.where(account_id: @current_user.id, order_request_id: params[:order_request_id] )
			if documents.present?
				render json: {order_details: BxBlockOrdercreation3s::CarOrderSerializer.new(documents).serializable_hash }
			else
				render json: { message: "Order not Found" },status: 404
			end
  	end

  	def order_cancelled
  		order = BxBlockOrdercreation3::CarOrder.where(account_id: @account.id, order_request_id: params[:order_request_id] )
      if order.present?
        if order.update(status: "cancelled", cancelled_at: Time.current)
        	render json: { 
        						message: "order request cancelled successfully..",
        						order: order
        					}
        else
        	render json: {message: 'Unable to cancel this order'}, status: 422
        end 
        
  		else
  			render json: {message: "order request not found"},status: 404
  		end
  	end

  	def payment
	    return render json: {success: false, message: 'Instant deposit payment already done'}, status: 422 if @car_order.instant_deposit_status_confirmed?
	    
	    stripe_card_id = 
	      if params[:card_id].present?
	        params[:card_id]
	      else
	        BxBlockPayments::CreditCardService.new(@current_user.id, card_params).create_credit_card
	      end

	    stripe_service = BxBlockPayments::StripeIntegrationService.new(@current_user.id)
	    # stripe_service.stripe_charge(payment_attributes.merge(stripe_card_id: stripe_card_id))
	    payment_response = stripe_service.stripe_payment_intent(payment_attributes.merge(stripe_card_id: stripe_card_id))
	    
	    if payment_response&.id.present?
	      # action_type = payment_response.next_action.use_stripe_sdk.type
	      # auth_url = nil
	      # if action_type == 'three_d_secure_redirect'
	      #   auth_url = payment_response.next_action.use_stripe_sdk.stripe_js
	      # end
	      
	      BxBlockPayments::PaymentTransaction.create(account_id: @current_user.id, target_type: 'BxBlockOrdercreation3::CarOrder', target_id: @car_order.id, status: 0, payload: payment_attributes.merge(stripe_card_id: stripe_card_id), transaction_id: payment_response&.id)

	      render json: {success: true, url: '', payment_id: payment_response&.id}, status: 200
	    else
	      render json: {success: false, message: 'Unable to initiate payment process'}, status: 422
	    end
	  end

	  def payment_status
			if params[:transaction_id].present?
				transaction = BxBlockPayments::PaymentTransaction.find_by(account_id: @current_user.id, transaction_id: params[:transaction_id])
				return render json: {status: 422, message: 'Invalid transaction'}, status: 422 if transaction.blank?

				render json: {status: 200, payment_success: transaction.completed? }, status: 200
			else
				render json: {status: 422, message: 'Required Input missing'}, status: 422
			end
	  end

	  def request_inspection
	  	ActiveRecord::Base.transaction do 
		  	if @car_order.update(status: "inspection requested")
		  		car_ad = @car_order&.car_ad
		  		inspection_charge = BxBlockRateCard::InspectionCharge.where("lower(country) = ?", @car_order.country.downcase).try(:first)
		  		report_available = BxBlockAdmin::VehicleInspection.exists?(car_ad_id: car_ad.id, status: 'completed')

		  		attr = {
		  			model_id: car_ad&.model&.id,
		  			account_id: @car_order&.account_id,
		  			make_year: car_ad&.make_year,
		  			seller_mobile_number: @car_order.full_phone_number,
		  			inspection_amount: inspection_charge&.price,
		  			car_ad_id: car_ad.id,
		  			final_sale_amount: @car_order.final_sale_amount,
		  			instant_deposit_amount: @car_order.instant_deposit_amount
		  		}

		  		vehicle_inspection = BxBlockAdmin::VehicleInspection.create(attr)
		  		@car_order.update(vehicle_inspection_id: vehicle_inspection.id)
		  		
		  		render json: {status: 200, inspection_id: vehicle_inspection.id, report_available: report_available, inspection_amount: inspection_charge&.price }, status: 200
		  	end
		  end
	  end

	  def buy_car
	  	if @car_order.update(status: 'pre booked')
	  		render json: {data: BxBlockOrdercreation3s::CarOrderSerializer.new(order).serializable_hash, status: 200}, status: 200
	  	else
	  		render json: {status: 422, message: 'Unable to update order status'}, status: 422
	  	end
	  end

  	private 

  	def set_current_user
    	@current_user ||= AccountBlock::Account.find_by(id: @token.id)
    	return render json: {errors: 'Account Not Found'}, :status => :not_found if @current_user.blank?
  	end

  	def load_car_order
  		@car_order = BxBlockOrdercreation3::CarOrder.find_by(account_id: @current_user.id, order_request_id: params[:order_request_id])
  		return render json: {status: 422, message: 'Invalid order details'}, status: 422 if @car_order.blank?
  	end

    def valid_phone_number full_phone_number
      unless Phonelib.valid?(full_phone_number)
        "Invalid or Unrecognized Phone Number"
      end
    end

  	def create_params
  		params.require(:data).permit(:continent, :country, :state, :area, :country_code, :phone_number, :full_phone_number, :car_ad_id)
  	end

  	def document_params
  		params.require(:data).permit(:payment_receipt, :passport, :notes, :order_request_id, :instant_deposit_status, :final_invoice_payment_status, :other_documents => [])
  	end

  	def card_params
      params.require(:card).permit(:number, :month, :year, :cvc)
    end

    def payment_attributes
      {
        amount: @car_order.instant_deposit_amount,
        currency: 'usd',
        description: 'Car Order - Instant deposit',
        metadata: {type: 'BxBlockOrdercreation3::CarOrder', id: @car_order.id},
      }
    end

	end
end
