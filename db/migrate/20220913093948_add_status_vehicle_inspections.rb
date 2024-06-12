class AddStatusVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :status, :integer, default: 0
  end
end
