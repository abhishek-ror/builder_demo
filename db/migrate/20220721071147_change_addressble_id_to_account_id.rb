class ChangeAddressbleIdToAccountId < ActiveRecord::Migration[6.0]
  def change
    rename_column :addresses, :addressble_id, :account_id
    rename_column :accounts, :country_name, :country

  end
end
