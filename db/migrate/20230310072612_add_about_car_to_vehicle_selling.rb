class AddAboutCarToVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :about_car, :text
  end
end
