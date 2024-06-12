class AddCarToAccount < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :temp_car_ad_id, :bigint
  end
end
