class AddCarAdIdToVehicleOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :vehicle_orders, :car_ad_id, :bigint 
  end
end
