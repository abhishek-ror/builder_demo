class ChangeTableNameCarOrderToCarOrders < ActiveRecord::Migration[6.0]
  def change
    rename_table :car_order, :car_orders
  end
end
