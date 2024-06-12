class CreateEngineTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :car_engine_types do |t|
      t.string :name
      t.string :engine_type

      t.timestamps
    end
  end
end
