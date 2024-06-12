module BxBlockPayments
	class StripeWebhookController < ApplicationController
		skip_before_action :verify_authenticity_token
		skip_before_action :validate_json_web_token
		before_action :verification
		
		def callback
		  case @event['type']
		  when 'payment_intent.succeeded', 'charge.succeeded'
		  	BxBlockPayments::PaymentTransaction.update_completed_status(@event.data.object) unless @event.data.object.charges.present?
		  when 'payment_intent.payment_failed'
		  	BxBlockPayments::PaymentTransaction.update_failed_status(@event.data.object)
		  when 'charge.failed'
		  	BxBlockPayments::PaymentTransaction.update_failed_status(@event.data.object)
		  # when 'checkout.session.completed'
		  # 	BxBlockPayments::PaymentTransaction.create_transaction(event.data.object)
		  end
		    
		  render json: { success: true }, status: :ok    
		end

		def payment_link_response
			case @event['type']
			when 'checkout.session.completed'
	  		BxBlockPayments::PaymentTransaction.create_transaction(@event.data.object)
	  	end
			render json: { success: true }, status: :ok    
		end

		private

		def verification
			begin
		    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
		    payload = request.body.read
		    @event = Stripe::Event.construct_from(
		      JSON.parse(payload, symbolize_names: true)
		    )
		  rescue JSON::ParserError => e
		    # Invalid payload
		    return status 400
		  rescue Stripe::SignatureVerificationError => e
		    # Invalid signature
		    return status 400
		  end
		end

	end
end