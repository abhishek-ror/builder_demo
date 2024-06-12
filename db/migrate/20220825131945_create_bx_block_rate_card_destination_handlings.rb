class CreateBxBlockRateCardDestinationHandlings < ActiveRecord::Migration[6.0]
  def change
    create_table :destination_handlings do |t|
      t.string :source_country
      t.string :destination_country
      t.string :unloading
      t.string :customs_clearance
      t.string :storage

      t.timestamps
    end
  end
end
