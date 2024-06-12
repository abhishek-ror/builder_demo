class RemoveCarAdTypeFromVehicleInspections < ActiveRecord::Migration[6.0]
  def change
  	  remove_column :vehicle_inspections, :car_ad_type
  end
end
