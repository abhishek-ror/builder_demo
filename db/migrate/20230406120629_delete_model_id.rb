class DeleteModelId < ActiveRecord::Migration[6.0]
  def change
  	remove_column :vehicle_selling_inspections, :model_id
  	add_column :vehicle_selling_inspections, :model, :string
  end
end
