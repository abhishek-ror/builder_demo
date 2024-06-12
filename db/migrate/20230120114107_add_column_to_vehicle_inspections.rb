class AddColumnToVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :regional_spec, :string
  end
end
