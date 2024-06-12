class AddTrackingStatusToVehicleSellings < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :tracking_status, :integer, default: 0
  end
end
