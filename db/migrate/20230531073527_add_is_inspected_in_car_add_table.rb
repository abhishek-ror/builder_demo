class AddIsInspectedInCarAddTable < ActiveRecord::Migration[6.0]
  def change
  	add_column :car_ads, :is_inspected, :boolean, default: false
  end
end
