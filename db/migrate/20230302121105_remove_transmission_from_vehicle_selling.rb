class RemoveTransmissionFromVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_sellings, :transmission, :integer
  end
end
