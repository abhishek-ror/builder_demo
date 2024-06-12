class CreateJoinTableModelEngineTypes < ActiveRecord::Migration[6.0]
  def change
    create_join_table :models, :car_engine_types do |t|
      t.index [:model_id, :car_engine_type_id], name: 'idx_model_engine_type'
      t.index [:car_engine_type_id, :model_id], name: 'idx_engine_type_id_model_id'
    end

    drop_table :transmission_types
    drop_table :car_fuel_types
  end
end
