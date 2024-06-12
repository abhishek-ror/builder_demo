class CreateBxBlockAdminBanners < ActiveRecord::Migration[6.0]
  def change
    create_table :banners do |t|
      t.integer :priority

      t.timestamps
    end
  end
end
