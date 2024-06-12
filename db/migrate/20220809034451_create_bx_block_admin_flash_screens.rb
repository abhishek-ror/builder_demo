class CreateBxBlockAdminFlashScreens < ActiveRecord::Migration[6.0]
  def change
    create_table :flash_screens do |t|
      t.integer :screen_type
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
