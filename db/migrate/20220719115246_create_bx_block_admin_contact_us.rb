class CreateBxBlockAdminContactUs < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_us do |t|
      t.text :description
      t.string :phone_no

      t.timestamps
    end
  end
end
