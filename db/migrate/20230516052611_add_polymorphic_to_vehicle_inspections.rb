class AddPolymorphicToVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :car_ad_type, :string, default: "car ad"
  end
end
