class RemoveOtpFromVehicleSelling < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_sellings, :otp, :string
  end
end
