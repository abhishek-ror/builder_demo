class AddTrackingNumberToVehicleSellings < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :tracking_number, :string
  end
end
