class AddShippingStatusInVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :shipping_status, :integer
  end
end
