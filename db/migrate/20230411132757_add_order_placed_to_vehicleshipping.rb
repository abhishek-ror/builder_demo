class AddOrderPlacedToVehicleshipping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :order_placed, :boolean, default: 'false'
  end
end

