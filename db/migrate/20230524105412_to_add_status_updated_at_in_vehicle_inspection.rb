class ToAddStatusUpdatedAtInVehicleInspection < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :status_updated_at, :datetime
  end
end
