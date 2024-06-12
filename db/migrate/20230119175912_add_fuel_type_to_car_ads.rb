class AddFuelTypeToCarAds < ActiveRecord::Migration[6.0]
  def change
    add_column :car_ads, :fuel_type, :integer, default: 0
  end
end
