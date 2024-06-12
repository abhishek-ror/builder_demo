class AddInstantDepositAmountInVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :instant_deposit_amount, :float
  end
end
