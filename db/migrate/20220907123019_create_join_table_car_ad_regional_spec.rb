class CreateJoinTableCarAdRegionalSpec < ActiveRecord::Migration[6.0]
  def change
    create_join_table :car_ads, :regional_specs do |t|
      t.index [:car_ad_id, :regional_spec_id]
      t.index [:regional_spec_id, :car_ad_id]
    end
  end
end
