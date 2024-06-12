class ToAddColumnInVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :payment_type, :integer
  end
end
