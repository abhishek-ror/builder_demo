class CreateBxBlockAdminGlobalOffices < ActiveRecord::Migration[6.0]
  def change
    create_table :global_offices do |t|
      t.text :address
      t.string :contact_email
      t.string :contact_no

      t.timestamps
    end
  end
end
