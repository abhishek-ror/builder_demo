class AddTransactionToVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :transaction_id, :string
    add_column :vehicle_shippings, :transaction_date, :datetime
    add_column :vehicle_shippings, :payment_status, :string, default: 'pending'
    add_column :vehicle_shippings, :amount_paid, :string
    add_column :vehicle_shippings, :approved_by_admin, :boolean, default: 'false'
    add_column :vehicle_shippings, :vehicle_pickup, :boolean, default: 'false'
    
 end
end
