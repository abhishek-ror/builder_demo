class ChangeDataTypeOfSteeringSideInVehicleSelling < ActiveRecord::Migration[6.0]
  def change
  	change_column :vehicle_sellings, :steering_side, :string
  end
end
