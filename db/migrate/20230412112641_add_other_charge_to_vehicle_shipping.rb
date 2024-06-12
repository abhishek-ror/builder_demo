class AddOtherChargeToVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :other_charge, :string
  end
end

