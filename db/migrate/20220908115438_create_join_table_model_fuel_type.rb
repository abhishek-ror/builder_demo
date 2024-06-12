class CreateJoinTableModelFuelType < ActiveRecord::Migration[6.0]
  def change
    create_join_table :models, :car_fuel_types do |t|
      t.index [:model_id, :car_fuel_type_id]
      t.index [:car_fuel_type_id, :model_id]
    end
  end
end
