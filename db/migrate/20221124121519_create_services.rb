class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.string :logo
      t.string :title
      t.text   :description
      t.timestamps
    end
  end
end
