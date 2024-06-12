class ChangingCloumnInVehicleOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :vehicle_orders, :vehicle_inspection_id, :bigint
  end
end
