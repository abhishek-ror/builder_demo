class AddNewColumnInVehicleShpping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :export_title, :string
    add_column :vehicle_shippings, :notes_for_admin, :text
  end
end
