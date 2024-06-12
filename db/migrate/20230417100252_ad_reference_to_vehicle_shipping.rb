class AdReferenceToVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicle_shippings, :service_shippings, foreign_key: true
  end
end
