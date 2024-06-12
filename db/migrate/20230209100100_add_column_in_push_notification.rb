class AddColumnInPushNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :push_notifications, :logo, :string
  end
end
