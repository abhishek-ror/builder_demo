class AddInspectorCodeInAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :inspector_code, :string
  end
end
