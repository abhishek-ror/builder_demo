class AddVehicleShippingsIdColumnsShipments < ActiveRecord::Migration[6.0]
  def change
    add_column :shipments, :vehicle_shipping_id, :integer
  end
end
