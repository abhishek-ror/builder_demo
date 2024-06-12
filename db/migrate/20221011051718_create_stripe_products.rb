class CreateStripeProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_products do |t|
      t.string :name, null: false
      t.string :product_id

      t.timestamps
    end
  end
end
