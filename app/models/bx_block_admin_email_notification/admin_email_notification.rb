module BxBlockAdminEmailNotification
  class AdminEmailNotification < BxBlockAdminEmailNotification::ApplicationRecord
		self.table_name = :admin_email_notifications

        enum notification_name: {'Individual & Business - Account Verification (New user)': 0, 'Inspector Registration - Account verification': 1, "Verify Your Account/ Forgot Password/ Change Password": 2, "Selling flow ads OTP": 3}
        validates :content, presence: true
	end
end