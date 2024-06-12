class RemoveStatusFromVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_sellings, :status, :string
  end
end




