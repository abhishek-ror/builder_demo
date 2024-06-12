class AddTotalAdToAccount < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :total_ads, :integer, default: 3
  end
end
