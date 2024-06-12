class CreateTransmissionType < ActiveRecord::Migration[6.0]
  def change
    create_table :transmission_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
