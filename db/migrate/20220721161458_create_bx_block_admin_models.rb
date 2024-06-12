class CreateBxBlockAdminModels < ActiveRecord::Migration[6.0]
  def change
    create_table :models do |t|
      t.string :name
      t.string :body_type
      t.string :engine_type
      t.integer :no_of_doors
      t.integer :no_of_cylinder
      t.integer :horse_power
      t.boolean :warranty
      t.integer :battery_capacity
      t.boolean :autopilot
      t.integer :autopilot_type

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
