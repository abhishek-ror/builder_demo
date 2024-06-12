class CreateVehicleSellingInspection < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_selling_inspections do |t|
      t.references :city, null: false, foreign_key: true
      t.references :model, null: false, foreign_key: true
      t.references :account, foreign_key: true
      t.references :admin_user, foreign_key: true
      t.integer :make_year
      t.text :about
      t.float :price
      t.string :vin_numbers
      t.string :seller_name
      t.string :seller_mobile_number
      t.string :seller_email
      t.float :inspection_amount
      t.text :notes_for_the_inspector
      t.integer :status, default: 0
      t.integer :vehicle_selling_id
      t.integer :inspector_id
      t.integer :acceptance_status
      t.text :instant_deposit_link
      t.text :notes_for_the_admin
      t.float :final_sale_amount
      t.date :inspection_scheduled_on
      t.integer :instant_deposit_status, default: 0
      t.integer :final_invoice_status, default: 0
      t.float :instant_deposit_amount
      t.string :stripe_payment_link_id
      t.integer :payment_link_active
      t.string :seller_country_code
      t.string :advertisement_url
      t.string :regional_spec
      t.timestamps
    end
  end
end
