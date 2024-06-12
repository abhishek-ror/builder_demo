class AddIsInspectedToNotifications < ActiveRecord::Migration[6.0]
  def change
  	add_column :push_notifications, :is_inspected, :boolean, default: false
  end
end
