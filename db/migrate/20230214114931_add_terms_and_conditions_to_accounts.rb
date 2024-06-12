class AddTermsAndConditionsToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :terms_and_conditions, :boolean
  end
end
