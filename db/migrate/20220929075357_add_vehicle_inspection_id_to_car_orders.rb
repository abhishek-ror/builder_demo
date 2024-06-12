class AddVehicleInspectionIdToCarOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :car_orders, :vehicle_inspection_id, :integer
    add_index :car_orders, :vehicle_inspection_id
  end
end
