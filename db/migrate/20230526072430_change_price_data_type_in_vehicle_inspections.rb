class ChangePriceDataTypeInVehicleInspections < ActiveRecord::Migration[6.0]
  def change
  	change_column :vehicle_inspections, :price, :string
  end
end
