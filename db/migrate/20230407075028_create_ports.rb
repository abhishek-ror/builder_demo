class CreatePorts < ActiveRecord::Migration[6.0]
  def change
    create_table :ports do |t|
      t.string :port_name
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
