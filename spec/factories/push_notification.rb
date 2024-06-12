FactoryBot.define do
	factory :push_notification, class: 'BxBlockPushNotifications::PushNotification' do
		account_id { 1 }
		remarks {"your notification"}
		notify_type {"AccountBlock::Account"}
		push_notificable_id { 1 }
		push_notificable_type {"AccountBlock::Account"}
		is_read {false}
	end
end
