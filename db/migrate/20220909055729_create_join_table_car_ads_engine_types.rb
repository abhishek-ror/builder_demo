class CreateJoinTableCarAdsEngineTypes < ActiveRecord::Migration[6.0]
  def change
    create_join_table :car_ads, :car_engine_types do |t|
      t.index [:car_ad_id, :car_engine_type_id], name: 'idx_car_ad_id_engine_type'
      t.index [:car_engine_type_id, :car_ad_id], name: 'idx_engine_type_id_car_ad_id'
    end
  end
end
