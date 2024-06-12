class RemoveNotNullCityVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    change_column_null :vehicle_inspections, :city_id, true
    change_column_null :vehicle_inspections, :model_id, true
  end
end
