class CreateBxBlockAdminEmailNotificationAdminEmailNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_email_notifications do |t|
      t.integer :notification_name
      t.text :content

      t.timestamps
    end
  end
end
