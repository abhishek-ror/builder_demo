class RemoveAdminUserFromVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    remove_reference :vehicle_sellings, :admin_user, foreign_key: true
  end
end
