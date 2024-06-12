class AddStatusToVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :status, :string, default: 'sold'
  end
end
