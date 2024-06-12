FactoryBot.define do
    factory :admin_email_notification, class: "BxBlockAdminEmailNotification::AdminEmailNotification" do
      notification_name { 'Selling flow ads OTP' }
      content { 'Content 1' }
    end
end