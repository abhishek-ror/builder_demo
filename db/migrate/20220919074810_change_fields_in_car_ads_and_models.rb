class ChangeFieldsInCarAdsAndModels < ActiveRecord::Migration[6.0]
  def change
    remove_column :models, :warranty, :boolean
    remove_column :models, :horse_power, :integer
    remove_column :models, :no_of_cylinder, :integer
    remove_column :models, :battery_capacity, :integer
    remove_column :models, :no_of_doors, :integer

    add_column :car_ads, :warranty, :boolean
    add_column :car_ads, :horse_power, :integer
    add_column :car_ads, :no_of_cylinder, :integer
    add_column :car_ads, :battery_capacity, :integer
    add_column :car_ads, :no_of_doors, :integer

  end
end
