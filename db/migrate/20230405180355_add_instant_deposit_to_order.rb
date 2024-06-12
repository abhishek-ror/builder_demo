class AddInstantDepositToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :vehicle_orders, :instant_deposit_amount, :float
    add_column :vehicle_orders, :instant_deposit_status, :integer
  end
end
