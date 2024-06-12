class AddReferenceInVehiclePayment < ActiveRecord::Migration[6.0]
  def change
  	add_reference :vehicle_payments, :car_ad, index: true
  end
end
