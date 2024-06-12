class CreatePaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_transactions do |t|
      t.references :account, foreign_key: true
      t.string :target_type
      t.integer :target_id
      t.string :transaction_id, null: false
      t.integer :status
      t.jsonb :payload

      t.timestamps
    end

    add_index :payment_transactions, [:target_type, :target_id]
  end
end
