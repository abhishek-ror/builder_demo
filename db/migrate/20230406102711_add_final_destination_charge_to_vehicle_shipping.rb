class AddFinalDestinationChargeToVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :final_destination_charge, :string
  end
end
