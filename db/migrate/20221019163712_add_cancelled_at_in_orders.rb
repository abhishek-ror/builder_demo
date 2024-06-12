class AddCancelledAtInOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :car_orders, :cancelled_at, :datetime
  end
end
