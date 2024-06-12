class AddingNullTrueForVehiclePayments < ActiveRecord::Migration[6.0]
  def change
  	change_column_null :vehicle_payments, :vehicle_selling_id, true
  end
end
