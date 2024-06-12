class AddInstantDepositLinkVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :instant_deposit_link, :text
    add_column :vehicle_inspections, :notes_for_the_admin, :text
  end
end
