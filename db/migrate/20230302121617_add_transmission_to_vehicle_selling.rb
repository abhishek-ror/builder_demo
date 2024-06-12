class AddTransmissionToVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :transmission, :string
  end
end
