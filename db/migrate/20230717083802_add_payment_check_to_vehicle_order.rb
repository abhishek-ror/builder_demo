class AddPaymentCheckToVehicleOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :vehicle_orders, :payment_check, :boolean, default: false
  end
end
