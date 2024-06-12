class AddNewColumnToShipments < ActiveRecord::Migration[6.0]
  def change

    remove_column :shipments, :status, :string
    remove_column :shipments, :delivery_status, :string


    add_column :shipments, :status, :integer
    add_column :shipments, :delivery_status, :integer

  end
end
