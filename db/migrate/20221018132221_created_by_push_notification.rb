class CreatedByPushNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :push_notifications, :created_by, :integer
  end
end
