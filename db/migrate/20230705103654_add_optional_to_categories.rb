class AddOptionalToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :optional, :boolean
  end
end
