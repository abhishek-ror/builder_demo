class CreateVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_inspections do |t|
      t.references :city, null: false, foreign_key: true
      t.references :model, null: false, foreign_key: true
      t.references :account, foreign_key: true
      t.references :admin_user, foreign_key: true
      t.integer :make_year
      t.text :about
      t.float :price
      t.string :vin_number
      t.string :seller_name
      t.string :seller_mobile_number
      t.string :seller_email
      t.float :inspection_amount
      t.text :notes_for_the_inspector

      t.timestamps
    end

    add_index :vehicle_inspections, :seller_mobile_number
    add_index :vehicle_inspections, :seller_email
  end
end
