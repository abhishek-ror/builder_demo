class CreateJoinTableModelTransmissionType < ActiveRecord::Migration[6.0]
  def change
    create_join_table :models, :transmission_types do |t|
      t.index [:model_id, :transmission_type_id], name: 'idx_model_transmission_type'
      t.index [:transmission_type_id, :model_id], name: 'idx_transmission_type_id_model_id'
    end
  end
end
