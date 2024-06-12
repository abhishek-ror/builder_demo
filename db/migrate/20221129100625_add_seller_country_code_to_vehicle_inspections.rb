class AddSellerCountryCodeToVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :seller_country_code, :string
  end
end
