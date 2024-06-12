class AddItemTypeImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :item_type, :string
  end
end
