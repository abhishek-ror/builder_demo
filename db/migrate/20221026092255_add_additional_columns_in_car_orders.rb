class AddAdditionalColumnsInCarOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :shipments, :payment_mode, :integer
    add_column :shipments, :payment_status, :integer
  end
end
