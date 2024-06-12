class AddAdCountToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :ad_count, :integer
  end
end
