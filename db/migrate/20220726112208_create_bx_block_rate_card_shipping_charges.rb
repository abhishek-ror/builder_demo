class CreateBxBlockRateCardShippingCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :shipping_charges do |t|
      t.string :destination_country
      t.string :destination_port
      t.string :price
      t.string :in_transit

      t.timestamps
    end
  end
end
