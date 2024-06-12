class ToAddFuelTypeDescriptionInCarAd < ActiveRecord::Migration[6.0]
  def change
    add_column :car_ads, :fuel_type_description, :string
  end
end
