module BxBlockShipment
	class Shipment < ApplicationRecord
		self.table_name = :shipments
		include PushNotificationHelper
		include ActiveStorageSupport::SupportForBase64
		include TransactionHelper
		include StripePaymentLink

		belongs_to :car_order, class_name: 'BxBlockOrdercreation3::CarOrder', foreign_key: 'car_order_id', optional: true
		belongs_to :account, class_name: 'AccountBlock::Account'
		belongs_to :vehicle_shipping, class_name: 'BxBlockVehicleShipping::VehicleShipping', foreign_key: 'vehicle_shipping_id', optional: true

		# has_many :images, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
		# accepts_nested_attributes_for :images, allow_destroy: true
		
		# validates :car_order, uniqueness: true
		validates :estimated_time_of_departure, :estimated_time_of_arrival, :shipping_line, :container_number, :bl_number, :tracking_link, presence: true
		
		has_one_attached :payment_receipt
		has_one_attached :passport
    has_many_attached :other_documents
    has_many_attached :unloading_images
    has_many_attached :loading_images
    has_many_attached :delivery_proof

		# accepts_nested_attributes_for :payment_receipt_attachment, allow_destroy: true

		validate :check_arrival_date
		enum status: {"ready to ship": 6, "order shipped": 7, "arrived at destination": 8, "cancelled": 2, "delivered": 9, 'Canceled - Refund initiated': 13}
		enum payment_status: {'pending': 1, 'submitted': 2, 'confirmed': 3, 'failed': 4}, _prefix: true
		enum payment_mode: {'Bank Transfer': 1, 'Payment Link': 2}, _prefix: true
		enum payment_link_active: {'Yes': 0, 'No': 1}

		enum delivery_status: {"Accept Shipping & Close the Order": 0,
        "Unloading & close the Order": 1,
        "Unloading,Customs Clearance & Close the Order": 2,
        "Unloading,Customs Clearance,Delivery & Close the Order": 3,
        "Unloading,Customs Clearance,Delivery,Miscellaneous services & Close the Order": 4}

    after_update :update_order_status
    after_save :send_notification
    before_save :payment_link_generation
    
		private 

		def update_order_status
			if saved_change_to_payment_status? && payment_status_confirmed?
				deactivate_payment_link
			end
		end

		def check_arrival_date
			if self.estimated_time_of_arrival.blank? || self.estimated_time_of_departure.blank?
				errors.add(:estimated_time_of_arrival, "Please select date")
				errors.add(:estimated_time_of_departure, "Please select date")
			elsif (self.estimated_time_of_arrival <  self.estimated_time_of_departure)
				errors.add(:estimated_time_of_arrival, "Arrival date should be greater than Departure date")
			end
		end

		def send_notification
			if saved_change_to_delivery_status?
				push_notification('Notification regarding Delivery and Payment link')

			elsif saved_change_to_payment_mode?
				push_notification('Notification regarding Delivery and Payment option')				
			end
		end

		def payment_link_generation
			if ((destination_cost_changed? && destination_cost.to_f > 0.0 && payment_mode == 'Payment Link') || (payment_mode_changed? && payment_mode == 'Payment Link' && destination_cost.to_f > 0.0) )
	      if stripe_payment_link_id.present? && payment_link.present? && payment_link_active == 'Yes'
	        deactivate_payment_link
	      end
	      create_instant_payment_link      
	    end
		end

		def create_instant_payment_link
	    metadata = {type: self.class.name, id: self.id, name: 'Shipment Delivery Service Payment', account_id: self.account_id}
	    req_amount = (self.destination_cost * 100).to_i
	    link_res = generate_payment_link('Shipment Delivery Service Payment', req_amount, metadata)
	  
	    if link_res.present?
	      update_columns(payment_link: link_res.url, payment_link_active: 0, stripe_payment_link_id: link_res.id)
	    end
	  end

	  def deactivate_payment_link
	  	if stripe_payment_link_id.present?
	      response = update_payment_link(stripe_payment_link_id, false)
	      if response.present? && response&.id.present? && response&.active.blank?
	       update_columns(payment_link_active: 1) 
	      end
	    end
	  end
	end
end
