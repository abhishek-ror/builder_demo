class CreateJoinTableCarAdFeature < ActiveRecord::Migration[6.0]
  def change
    create_join_table :car_ads, :features do |t|
      t.index [:car_ad_id, :feature_id]
      t.index [:feature_id, :car_ad_id]
    end
  end
end
