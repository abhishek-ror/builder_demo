class AddCheckForCompletion < ActiveRecord::Migration[6.0]
  def change
  	add_column :push_notifications, :completion_check, :boolean, default: false
  end
end
