class CreateJoinTableCarAdColor < ActiveRecord::Migration[6.0]
  def change
    create_join_table :car_ads, :colors do |t|
      t.index [:car_ad_id, :color_id]
      t.index [:color_id, :car_ad_id]
    end
  end
end
