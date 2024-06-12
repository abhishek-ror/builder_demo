class RenameShipmentToShipmentNotiInVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    rename_column :vehicle_shippings, :shipment, :shipment_noti

  end
end
