module BxBlockVehicleShipping
  class VehicleOrder < ApplicationRecord
  	self.table_name = :vehicle_orders
  	before_create :generate_order_id
    after_create :update_status
    after_save :check_final_invoice
    before_save :send_notification_selling
  	belongs_to :account, class_name: 'AccountBlock::Account', optional: true, foreign_key: :account_id
  	belongs_to :vehicle_selling, class_name: 'BxBlockVehicleShipping::VehicleSelling', optional: true, foreign_key: :vehicle_selling_id
    belongs_to :car_ad, class_name: 'BxBlockAdmin::CarAd',foreign_key: 'car_ad_id', optional: true
    belongs_to :vehicle_inspection, class_name: 'BxBlockAdmin::VehicleInspection', foreign_key: 'vehicle_inspection_id', optional: true
    belongs_to :vehicle_shipping, class_name: 'BxBlockVehicleShipping::VehicleShipping', foreign_key: 'vehicle_shipping_id', optional: true
  	after_save :change_final_sale_amount
      
  	enum status:{ "pending": 1, "closed": 10, "inspection requested": 3, "pre booked": 4, "instant deposit": 11, 
                    "final invoice payment": 12, "ready to ship": 6, "order shipped": 7, "arrived at destination": 8, 
                    "delivered": 9, "cancelled": 2, "sold": 5, 'Canceled - Refund initiated': 13
                  }
    validates :country, :country_code, :phone_number, presence: true
    validates :final_invoice, content_type: {in: 'application/pdf',message: "Attachment must be PDF only"}

     validates :instant_deposit_amount, :final_sale_amount, numericality: { greater_than: 0, message: 'must be greater than 0' }, allow_blank: true

    has_one_attached :final_invoice
    has_one_attached :payment_receipt
    has_one_attached :passport
    has_many_attached :other_documents

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

    def update_status
      update_columns(status_updated_at: Time.now)
    end

    def check_final_invoice
      if self.final_invoice.attached?
        unless BxBlockPushNotifications::PushNotification.where(account_id: self.account_id, notification_type_id: self.order_request_id, notification_type: "vehicle payment invoice").present?
          BxBlockPushNotifications::PushNotification.create(account_id: self.account_id, remarks: "Your final invoice has been generated. Tap to view.", notify_type: "Push Notification", push_notificable_id: self.account_id, push_notificable_type: "AccountBlock::Account", is_read: false, logo: @base_url, notification_type: "vehicle payment invoice", notification_type_id: self.order_request_id)
        end
      end
    end

    def send_notification_selling
      if self.final_sale_amount_changed? && self.instant_deposit_amount_changed?
        unless BxBlockPushNotifications::PushNotification.where(account_id: self.account_id, notification_type_id: self.order_request_id, notification_type: "buy request").present?
          is_inspected = false
          if self.vehicle_selling.present?
            is_inspected = self.vehicle_selling.is_inspected
          elsif self.car_ad.present?
            is_inspected = BxBlockAdmin::VehicleInspection.find_by(car_ad_id: self.car_ad.id).present? ? true : false
          end
          BxBlockPushNotifications::PushNotification.create(account_id: self.account_id, remarks: "Sale amount for the car is given by the admin. Please accept and pay the instant deposit.", notify_type: "Push Notification", push_notificable_id: self.account_id, push_notificable_type: "AccountBlock::Account", is_read: false, logo: @base_url, notification_type: "buy request", notification_type_id: self.order_request_id, is_inspected: is_inspected)
        end
      end
    end

    def change_final_sale_amount
      # if self.final_sale_amount_changed? && self.status == "active"
      if saved_change_to_final_sale_amount? && pending?
        update_columns(status_updated_at: Time.now)
        self.status_updated_at = Time.now
        # BxBlockOrdercreation3::OrderRequestStatusClosedWorker.perform_at(48.hours.from_now, self.id, "buy_request")
      end
    end
  end
end