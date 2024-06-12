class RenameColumnOfCarOrder < ActiveRecord::Migration[6.0]
  def change
    rename_column :car_orders, :source_country, :continent
    rename_column :car_orders, :pickup_port,    :country
    rename_column :car_orders, :destination_country, :state
    rename_column :car_orders, :destination_port, :area

  end
end
