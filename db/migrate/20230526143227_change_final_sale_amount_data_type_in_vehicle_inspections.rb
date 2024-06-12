class ChangeFinalSaleAmountDataTypeInVehicleInspections < ActiveRecord::Migration[6.0]
  def change
  	change_column :vehicle_inspections, :final_sale_amount, :string
  end
end
