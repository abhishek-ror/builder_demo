class RemovePriceFromVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_sellings, :price, :bigint
  end
end
