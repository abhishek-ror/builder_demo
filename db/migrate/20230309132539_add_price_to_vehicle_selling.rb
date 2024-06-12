class AddPriceToVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :price, :string
  end
end
