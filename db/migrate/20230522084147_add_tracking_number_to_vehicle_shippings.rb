class AddTrackingNumberToVehicleShippings < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :tracking_number, :string
  end
end
