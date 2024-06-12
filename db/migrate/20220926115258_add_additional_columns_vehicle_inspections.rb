class AddAdditionalColumnsVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :car_ad_id, :integer
    add_column :vehicle_inspections, :inspector_id, :integer
  end
end
