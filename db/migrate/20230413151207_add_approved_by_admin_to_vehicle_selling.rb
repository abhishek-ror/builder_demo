class AddApprovedByAdminToVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :approved_by_admin, :boolean, default: false
  end
end
