module BxBlockPushNotifications
  class PushNotification < ApplicationRecord
    require 'fcm'
    self.table_name = :push_notifications
    belongs_to :push_notificable, polymorphic: true
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :created_user, class_name: 'AccountBlock::Account', foreign_key: 'created_by', optional: true
    
    validates :remarks, presence:true
    has_one_attached :logo

    def logo_url
      if logo.attached?
        logo.service_url&.split('?')&.first
      elsif notify_type == "Inspection Report"
        "#{ActiveStorage::Current.host}/images/logo.png"
      end
    end

    before_create :update_push_notification
    after_create :send_push_notification


    def update_push_notification
      BxBlockPushNotifications::PushNotification.where(account_id: self.account_id, notification_type_id: self.id).where.not(remarks: "Your car has been picked up and being prepared for shipping at warehouse").update_all(completion_check: true)
      charset = %w{ 1 2 3 4 5 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      loop do
        order_number = "OR" + (0...8).map{ charset.to_a[rand(charset.size)] }.join
        next if self.class.find_by(random_key: order_number).present?
        self.random_key = order_number
        break
      end
    end
    def send_push_notification
      if push_notificable.activated && push_notificable.fcm_device_token
       fcm_device_token = []
       fcm_device_token << push_notificable.fcm_device_token
       reg = []
       fcm_device_token.each do |obj|
        reg << AccountBlock::Account.find_by(fcm_device_token: obj).fcm_device_token
       end
        fcm_client = FCM.new("AAAAXoc3RuY:APA91bF2wQ9aFieq-wytkmSbxG8n1rhaa2cDUKa4lf1J6Oep-R-otjFIejNGwZNQRYZ4YA0jYhJDqsfAnL0AmkHWx1wVCPR9PDE9dW2SvXlnf4XIfcJ-ylVY9rA7i87QK4fCP2e404KT") # set your FCM_SERVER_KEY
        options = { priority: 'high',
                    data: {
                      message: self.remarks,
                      notification_type: self.notification_type,
                      notification_type_id: self.notification_type_id,
                      id: self.id,
                      is_inspected: self.is_inspected
                    },
                    notification: {
                    body: self.remarks,
                    random_key: self.random_key,
                    sound: 'default'
                    }
                  }
        #fcm_device_token taken from frontend....
        registration_id = reg
        response = fcm_client.send(registration_id, options)
        puts response 
      end
    rescue Exception => e
      e
    end
  end
end
