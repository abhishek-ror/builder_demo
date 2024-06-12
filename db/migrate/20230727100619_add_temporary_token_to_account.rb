class AddTemporaryTokenToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :temporary_token, :string
  end
end
