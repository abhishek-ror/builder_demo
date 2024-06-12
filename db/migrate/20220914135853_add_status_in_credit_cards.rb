class AddStatusInCreditCards < ActiveRecord::Migration[6.0]
  def change
    add_column :credit_cards, :status, :integer
  end
end
