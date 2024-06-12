class AddColumnsToCarAds < ActiveRecord::Migration[6.0]
  def change
    add_column :car_ads, :kms, :string
    add_column :car_ads, :mobile_number, :string
  end
end
