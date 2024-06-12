class AddUrlToVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :advertisement_url, :string
  end
end
