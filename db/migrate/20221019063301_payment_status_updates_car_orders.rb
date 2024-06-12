class PaymentStatusUpdatesCarOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :car_orders, :instant_deposit_paid_at, :datetime
    add_column :car_orders, :final_invoice_paid_at, :datetime
  end
end
