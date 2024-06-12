class AddAccountIdToShipment < ActiveRecord::Migration[6.0]
  def change
    add_column :shipments, :account_id, :integer
  end
end
