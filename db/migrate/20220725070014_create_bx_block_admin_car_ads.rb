class CreateBxBlockAdminCarAds < ActiveRecord::Migration[6.0]
  def change
    create_table :car_ads do |t|
      t.references :city, null: false, foreign_key: true
      t.integer :make_year
      t.integer :mileage
      t.text :more_details
      t.string :regional_spec
      t.integer :steering_side
      t.string :body_color
      t.integer :transmission
      t.bigint :price
      t.integer :status, default: 0
      t.references :account, foreign_key: true
      t.references :admin_user, foreign_key: true
      t.references :trim, null: false, foreign_key: true
      t.string :order_id
      t.string :otp

      t.timestamps
    end
  end
end
