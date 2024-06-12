class AddInstantDepositDetailsCarOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :car_orders, :instant_deposit_amount, :float
    add_column :car_orders, :instant_deposit_status, :integer
  end
end
