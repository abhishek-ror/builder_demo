class AddNewColumnsInVehicleShipping < ActiveRecord::Migration[6.0]
  def change
  	add_column :vehicle_shippings, :picked_up_date, :datetime
  	add_column :vehicle_shippings, :onboarded_date, :datetime
  	add_column :vehicle_shippings, :arrived_date, :datetime
  	add_column :vehicle_shippings, :delivered_date, :datetime
  end
end
