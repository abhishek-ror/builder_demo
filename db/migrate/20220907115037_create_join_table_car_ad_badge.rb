class CreateJoinTableCarAdBadge < ActiveRecord::Migration[6.0]
  def change
    create_join_table :car_ads, :badges do |t|
      t.index [:car_ad_id, :badge_id]
      t.index [:badge_id, :car_ad_id]
    end
  end
end
