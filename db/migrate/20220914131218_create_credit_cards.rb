class CreateCreditCards < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_cards do |t|
      t.string :digits
      t.integer :month
      t.integer :year
      t.string :stripe_card_id

      t.timestamps
    end
  end
end
