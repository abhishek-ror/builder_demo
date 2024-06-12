class CreateJoinTableCarAdsSellerTypes < ActiveRecord::Migration[6.0]
  def change
    create_join_table :car_ads, :seller_types do |t|
      t.index [:car_ad_id, :seller_type_id], name: 'idx_car_ad_id_seller_type_id'
      t.index [:seller_type_id, :car_ad_id], name: 'idx_seller_type_id_car_ad_id'
    end
  end
end
