class AddTypeAndId < ActiveRecord::Migration[6.0]
  def change
  	add_column :push_notifications, :notification_type, :string
	add_column :push_notifications, :notification_type_id, :bigint  	
  end
end
