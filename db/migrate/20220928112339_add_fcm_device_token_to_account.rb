class AddFcmDeviceTokenToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :fcm_device_token, :string
  end
end
