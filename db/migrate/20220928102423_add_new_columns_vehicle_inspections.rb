class AddNewColumnsVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :final_sale_amount, :float
    add_column :vehicle_inspections, :inspection_scheduled_on, :date
  end
end
