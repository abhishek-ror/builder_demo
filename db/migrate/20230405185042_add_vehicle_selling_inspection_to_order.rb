class AddVehicleSellingInspectionToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :vehicle_orders, :vehicle_selling_inspection_id, :integer
  end
end
