module PushNotificationHelper
	extend ActiveSupport::Concern

	def push_notification(remarks, created_by=nil)
		BxBlockPushNotifications::PushNotification.create!(
      push_notificable_type: self.class.name,
      push_notificable_id: self.id,
      account_id: self.account_id,
      remarks: remarks,
      is_read: false,
      created_by: created_by
    )

	end

end