class AddAdTypeToCarAd < ActiveRecord::Migration[6.0]
  def change
    add_column :car_ads, :ad_type, :integer, default: 0
  end
end
