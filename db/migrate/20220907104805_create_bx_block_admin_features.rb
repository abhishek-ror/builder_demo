class CreateBxBlockAdminFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :features do |t|
      t.string :name

      t.timestamps
    end
  end
end
