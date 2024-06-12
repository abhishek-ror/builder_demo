class AddNewColumnInVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :onboard, :boolean, default: false
    add_column :vehicle_shippings, :shipment, :boolean, default: false
    add_column :vehicle_shippings, :arrived, :boolean, default: false
    add_column :vehicle_shippings, :destination_service, :boolean, default: false  
  end
end
