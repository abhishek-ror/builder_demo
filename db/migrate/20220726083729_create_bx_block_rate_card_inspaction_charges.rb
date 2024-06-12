class CreateBxBlockRateCardInspactionCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :inspection_charges do |t|
      t.string :country
      t.string :region 
      t.string :price

      t.timestamps
    end
  end
end
