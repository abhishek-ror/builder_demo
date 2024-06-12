module BxBlockOrdercreation3
  class CarOrder < ApplicationRecord
    self.table_name = :car_orders
    include ActiveStorageSupport::SupportForBase64
    include PushNotificationHelper

    belongs_to :account, class_name: 'AccountBlock::Account', foreign_key: 'account_id'
    belongs_to :car_ad, class_name: 'BxBlockAdmin::CarAd',foreign_key: 'car_ad_id', optional: true
    belongs_to :vehicle_inspection, class_name: 'BxBlockAdmin::VehicleInspection', foreign_key: 'vehicle_inspection_id', optional: true

    after_save :change_final_sale_amount
    before_create :generate_order_id
    before_save :check_pre_booked_status
    after_save :notification_after_upload_final_invoice
    after_save :update_order_status
    after_save :update_status_notification
    
    enum status:{ "pending": 1, "closed": 10, "inspection requested": 3, "pre booked": 4, "instant deposit": 11, 
                  "final invoice payment": 12, "ready to ship": 6, "order shipped": 7, "arrived at destination": 8, 
                  "delivered": 9, "cancelled": 2, "sold": 5, 'Canceled - Refund initiated': 13
                }
    enum instant_deposit_status: {'pending': 1, 'submitted': 2, 'confirmed': 3, 'failed': 4}, _prefix: true
    enum final_invoice_payment_status: {'pending': 0, 'submitted': 1, 'confirmed': 2, 'rejected': 3}, _prefix: true
    
    validates_associated :shipment
    validates :continent, :country, :state,:country_code, :phone_number, presence: true
    validates :final_invoice, content_type: {in: 'application/pdf',message: "Attachment must be PDF only"}  
    
    has_one_attached :final_invoice
    has_one_attached :payment_receipt
    has_one_attached :passport
    has_many_attached :other_documents
    has_one :shipment, class_name: 'BxBlockShipment::Shipment', dependent: :destroy, foreign_key: 'car_order_id'
    
    accepts_nested_attributes_for :shipment, allow_destroy: true

    private

    def update_order_status
      if saved_change_to_final_invoice_payment_status? && final_invoice_payment_status_confirmed?
        update_columns(status: "final invoice payment")

      elsif saved_change_to_instant_deposit_status? && instant_deposit_status_confirmed?
        update_columns(status: "instant deposit")
      end
    end

    def check_pre_booked_status
      if attachment_changes['final_invoice'].present? && self.status != "instant deposit"
        errors.add(:status, "Status should be instant deposit")
      end
    end

    def change_final_sale_amount
      if saved_change_to_final_sale_amount? && pending?
        push_notification("Sale amount for the car is given by the admin, Please accept and pay the instant deposit")
        
        update_columns(status_updated_at: Time.now)
      end
    end

    def notification_after_upload_final_invoice
      if attachment_changes['final_invoice'].present? && self.status == "instant deposit"
        push_notification("Your Final Invoice has been generated. Tap here to view.")
      end
    end

    def update_status_notification
      if saved_change_to_status?
        case status
        when 'ready to ship'
          push_notification("The car has been onboarded, click here to view shipping details")
        when 'arrived at destination'
          push_notification("Your shipment has arrived at the respective port")
        when 'delivered'
          push_notification("Your shipment is delivered kindly give us review")  
        end
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
    end

  end
end