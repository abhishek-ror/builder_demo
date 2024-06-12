class AddSubscriptonToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :subscription, :string
  end
end
