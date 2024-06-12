class AddFieldsToUserSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :user_subscriptions, :start_date, :date
    add_column :user_subscriptions, :expiry_date, :date
  end
end
