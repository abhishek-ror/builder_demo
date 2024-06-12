class ChangeColumnType < ActiveRecord::Migration[6.0]
  def change
  	change_column :push_notifications, :notification_type_id, :string
  end
end
