class AddCarTypeToCarAds < ActiveRecord::Migration[6.0]
  def change
    add_column :car_ads, :car_type, :integer, default: 0
  end
end
