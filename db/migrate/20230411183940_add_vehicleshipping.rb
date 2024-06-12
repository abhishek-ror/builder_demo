class AddVehicleshipping < ActiveRecord::Migration[6.0]
  def change
  	add_column :vehicle_orders, :vehicle_shipping_id, :integer
  end
end
