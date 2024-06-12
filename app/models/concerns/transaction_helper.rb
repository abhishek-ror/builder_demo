module TransactionHelper
	extend ActiveSupport::Concern

	class_methods do
		def update_completed_status(event)
		  if get_event_transaction(event)&.update(status: 'completed')
		  	case event.metadata.type
		  	when 'BxBlockAdmin::VehicleInspection'
		  		event.metadata.type.constantize.find_by_id(event.metadata.id)&.update(status: 'payment_confirmed')
		  	when 'BxBlockOrdercreation3::CarOrder'
		  		event.metadata.type.constantize.find_by_id(event.metadata.id)&.update(instant_deposit_status: 'confirmed', instant_deposit_paid_at: Time.current, status: "instant deposit")
		  	end
		  end
		end

		def update_failed_status(event)
		  if get_event_transaction(event)&.update(status: 'failed')
		  	case event.metadata.type
		  	when 'BxBlockAdmin::VehicleInspection'
		  		event.metadata.type.constantize.find_by_id(event.metadata.id)&.update(status: 'payment_failed')
		  	when 'BxBlockOrdercreation3::CarOrder'
		  		event.metadata.type.constantize.find_by_id(event.metadata.id)&.update(instant_deposit_status: 'failed')
		  	end
		  end
		end

		def create_transaction(event)
			transaction_id, target_obj = event.id, event.metadata
			BxBlockPayments::PaymentTransaction.create!(transaction_id: transaction_id, account_id: target_obj.account_id, target_type: target_obj.type, target_id: target_obj.id, status: 'completed')

			case event.metadata.type
	  		when 'BxBlockAdmin::VehicleInspection'
	  			event.metadata.type.constantize.find_by_id(event.metadata.id)&.update(instant_deposit_status: 'confirmed')
	  		when 'BxBlockShipment::Shipment'
	  			event.metadata.type.constantize.find_by_id(event.metadata.id)&.update(payment_status: 'confirmed')
	  		end
		end

		def get_event_transaction(event)
			transaction_id, target_obj = event.id, event.metadata
			BxBlockPayments::PaymentTransaction.find_by(target_type: target_obj.type, target_id: target_obj.id, transaction_id: transaction_id)
		end
		
	end

end