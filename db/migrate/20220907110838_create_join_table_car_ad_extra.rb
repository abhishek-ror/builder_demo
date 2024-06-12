class CreateJoinTableCarAdExtra < ActiveRecord::Migration[6.0]
  def change
    create_join_table :car_ads, :extras do |t|
      t.index [:car_ad_id, :extra_id]
      t.index [:extra_id, :car_ad_id]
    end
  end
end
