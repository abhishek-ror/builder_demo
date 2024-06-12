class CreateBxBlockAdminTrims < ActiveRecord::Migration[6.0]
  def change
    create_table :trims do |t|
      t.string :name
      t.references :model, null: false, foreign_key: true

      t.timestamps
    end
  end
end
