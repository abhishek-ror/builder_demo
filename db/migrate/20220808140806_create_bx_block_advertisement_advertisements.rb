class CreateBxBlockAdvertisementAdvertisements < ActiveRecord::Migration[6.0]
  def change
    create_table :advertisements do |t|
      t.string :name
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
