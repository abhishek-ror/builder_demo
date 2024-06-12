class AddDeviceTypetoAccount < ActiveRecord::Migration[6.0]
    def change
  	    add_column :accounts, :device_type, :string
    end
end
