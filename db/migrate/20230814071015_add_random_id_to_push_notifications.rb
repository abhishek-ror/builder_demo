class AddRandomIdToPushNotifications < ActiveRecord::Migration[6.0]
  def change
  	add_column :push_notifications, :random_key, :string
  end
end
