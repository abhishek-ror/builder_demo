class AddAdditionalColumnsVehicleShipments < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :order_request_id, :string
    add_column :vehicle_shippings, :order_confirmed_at, :datetime
    add_column :vehicle_shippings, :order_shipped_at, :datetime
    add_column :vehicle_shippings, :destination_reached_at, :datetime
    add_column :vehicle_shippings, :cancelled_at, :datetime
    add_column :vehicle_shippings, :delivered_at, :datetime
  end
end
