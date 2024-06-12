class CreateBxBlockAdminCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.references :region, null: false, foreign_key: true

      t.timestamps
    end
  end
end
