class AddFuelTypeInModels < ActiveRecord::Migration[6.0]
  def change
    create_table :car_fuel_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
