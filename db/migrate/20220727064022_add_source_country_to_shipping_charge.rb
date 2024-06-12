class AddSourceCountryToShippingCharge < ActiveRecord::Migration[6.0]
  def change
    add_column :shipping_charges, :source_country, :string

  end
end
