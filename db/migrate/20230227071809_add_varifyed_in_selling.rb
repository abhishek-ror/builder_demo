class AddVarifyedInSelling < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_sellings, :verified, :boolean, default: false
  end
end
