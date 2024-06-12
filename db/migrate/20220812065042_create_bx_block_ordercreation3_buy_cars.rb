class CreateBxBlockOrdercreation3BuyCars < ActiveRecord::Migration[6.0]
  def change
    create_table :car_order do |t|
      
      t.string :order_request_id
      t.string :source_country
      t.string :pickup_port
      t.string :destination_country
      t.string :destination_port
      t.string :country_code
      t.string :phone_number
      t.string :full_phone_number
      t.integer :account_id
      t.integer :car_ad_id
      t.integer :status
      t.string :final_sale_amount
      t.datetime :status_updated_at
      t.boolean :final_invoice_payment_status
      t.text :notes

      t.timestamps
    end
  end
end
