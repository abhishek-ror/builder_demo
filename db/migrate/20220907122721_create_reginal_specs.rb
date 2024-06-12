class CreateReginalSpecs < ActiveRecord::Migration[6.0]
  def change
    create_table :regional_specs do |t|
      t.string :name

      t.timestamps
    end
  end
end
