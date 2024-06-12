class CreateUserSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_subscriptions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
