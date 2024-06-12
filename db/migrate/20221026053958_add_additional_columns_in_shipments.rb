class AddAdditionalColumnsInShipments < ActiveRecord::Migration[6.0]
  def change
    add_column :shipments, :destination_cost, :float
    rename_column :shipments, :car_orders_id, :car_order_id
  end
end
