class CreateBxBlockVehicleShippingVehicleSellings < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_sellings do |t|
      t.references :city, foreign_key: true
      t.references :account, foreign_key: true
      t.references :admin_user, foreign_key: true
      t.references :trim, foreign_key: true
      t.references :region, foreign_key: true
      t.references :country, foreign_key: true
      t.references :state, foreign_key: true
      t.integer :year
      t.string :model
      t.string :regional_spec
      t.string :kms
      t.string :body_type
      t.string :body_color
      t.string :seller_type
      t.string :engine_type
      t.integer :steering_side
      t.string :badges
      t.string :features
      t.string :otp
      t.string :make
      t.integer :no_of_doors
      t.integer :transmission
      t.bigint :price
      t.integer :warranty
      t.integer :no_of_cylinder
      t.float :horse_power
      t.string :contact_number
      t.timestamps
    end
  end
end
