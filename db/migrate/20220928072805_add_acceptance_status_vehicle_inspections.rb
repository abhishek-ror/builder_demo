class AddAcceptanceStatusVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :acceptance_status, :integer
  end
end
