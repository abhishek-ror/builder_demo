class AddUserIdInCreditCards < ActiveRecord::Migration[6.0]
  def change
    add_column :credit_cards, :account_id, :integer
  end
end
