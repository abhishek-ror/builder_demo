class CreateBxBlockRateCardDocumentationCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :documentation_charges do |t|
      t.string :country
      t.string :region 
      t.string :price
      t.timestamps
    end
  end
end
