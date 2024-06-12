class CreateVehiclePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_payments do |t|
      t.references :account, null: false, foreign_key: true
      t.string :transaction_id
      t.string :status
      t.integer :amount
      t.datetime :date
      t.references :vehicle_selling, null: false, foreign_key: true
      t.timestamps
    end
  end
end

