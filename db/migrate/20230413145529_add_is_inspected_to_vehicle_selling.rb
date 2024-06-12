class AddIsInspectedToVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :is_inspected, :boolean, default: false
  end
end
