module BxBlockVehicleShipping
	class VehicleShipping < ApplicationRecord
		self.table_name = :vehicle_shippings

		belongs_to :account, class_name: 'AccountBlock::Account', optional: true
		include ActiveStorageSupport::SupportForBase64

		before_create :generate_tracking_number
		before_save :set_full_phone_number
		before_create :generate_order_id
		after_save :updating_vehicle_order
		before_save :set_cancelled_at, if: -> { status_changed? && status == 'cancelled' }

		before_save :set_picked_up_date, if: -> { shipping_status == 'picked up' }
		before_save :set_onboarded_date, if: -> { shipping_status == 'onboarded' }
		before_save :set_arrived_date, if: -> { shipping_status == 'arrived' }
		before_save :set_delivered_date, if: -> { shipping_status == 'delivered' }

		has_one_attached :shipping_invoice
		has_one_attached :payment_receipt
		has_many_attached :customer_payment_receipt
		has_one_attached :passport
		has_many_attached :other_documents
		has_one_attached :export_certificate
		has_many_attached :car_images
		has_one_attached :conditional_report
		has_many_attached :condition_pictures
		has_many_attached :delivery_proof
		has_many_attached :loading_image
		has_many_attached :unloading_image
		has_one_attached :delivery_invoice
		has_one_attached :export_title

		has_one :shipment, class_name: 'BxBlockShipment::Shipment', dependent: :destroy
		has_one :vehicle_order, class_name: 'BxBlockVehicleShipping::VehicleOrder'
		validates_associated :shipment
		validates :invoice_amount, numericality: { greater_than: 0, message: 'must be greater than 0' }, allow_blank: true
		validates :final_destination_charge, numericality: { greater_than: 0, message: 'must be greater than 0' }, allow_blank: true
		validates :year, numericality: { only_integer: true, greater_than: 0 }
 		validates :year, length: { minimum: 4, maximum: 4 }, allow_blank: true
		# has_many :image, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
		# accepts_nested_attributes_for :image
    
 		enum status: {'ongoing': 0, 'completed': 1, "cancelled": 2}
 		enum shipping_status: {"picked up": 0, "onboarded": 1, "arrived": 2, "delivered": 3}
 		enum payment_confirmation_status: {'pending': 0, 'submitted': 1, 'confirmed': 2, 'rejected': 3}, _prefix: true
 		enum payment_type: ["Cash", "Online"]
 		# before_save :update_status
 		# before_save :notification_for_shipping_charge

		private

		def updating_vehicle_order
			if saved_change_to_status? && self.vehicle_order.present?
				if self.status == "completed"
					self.vehicle_order.update(status: 9)
				elsif self.status == "cancelled"
					self.vehicle_order.update(status: 2)
				end
		    end
		end

		def set_picked_up_date
			self.picked_up_date ||= Time.now
		end

		def set_onboarded_date
			if self.picked_up_date.nil?
				self.picked_up_date = Time.now
			end
			self.onboarded_date = Time.now
		end

		def set_arrived_date
			if self.picked_up_date.nil?
				self.picked_up_date = Time.now
			end

			if self.onboarded_date.nil?
				self.onboarded_date = Time.now
			end
			self.arrived_date = Time.now
		end

		def set_delivered_date
			if self.picked_up_date.nil?
				self.picked_up_date = Time.now
			end

			if self.onboarded_date.nil?
				self.onboarded_date = Time.now
			end

			if self.arrived_date.nil? 
				self.arrived_date = Time.now
			end	
			
			self.delivered_date = Time.now			
		end
		
		def set_cancelled_at
    		self.cancelled_at = Time.now
		end

		def set_full_phone_number
			self.full_phone_number = self.country_code + self.phone_number  if self.country_code.present? && self.phone_number.present?
		end

		def update_status
			if attachment_changes['export_certificate'].present?  || attachment_changes['passport'].present?
				self.status = 0
			end
		end

		def generate_tracking_number
          charset = %w{ 1 2 3 4 5 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
          loop do
            tracking_id = "OR" + (0...8).map{ charset.to_a[rand(charset.size)] }.join
            next if self.class.find_by(tracking_number: tracking_id).present?
            self.tracking_number = tracking_id
            break
          end
        end

		def generate_order_id
      charset = %w{ 1 2 3 4 5 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      loop do
        order_number = "OR" + (0...8).map{ charset.to_a[rand(charset.size)] }.join
        next if self.class.find_by(order_request_id: order_number).present?
        self.order_request_id = order_number
        break
      end
      # self.order_request_id = "OR" + (0...8).map{ charset.to_a[rand(charset.size)] }.join
    end

		# notification send when shipping amount updated by admin
		def notification_for_shipping_charge
			if self.final_shipping_amount_changed?
				BxBlockPushNotifications::PushNotification.create(
                      push_notificable_type: 'AccountBlock::Account',
                      push_notificable_id: self.account_id,
                      account_id: self.account_id,
                      remarks: "Notification regarding final shipping amount.",
                      is_read: false,
                      notification_type_id: self.id
                    )
			end
		end

	end
end
