class VehiclePayment < ApplicationRecord
  belongs_to :account, class_name: 'AccountBlock::Account', optional: true, foreign_key: :account_id
  belongs_to :vehicle_order, class_name: 'BxBlockVehicleShipping::VehicleOrder', optional: true, foreign_key: :vehicle_selling_id
  belongs_to :car_ad, class_name: 'BxBlockAdmin::CarAd', optional: true, foreign_key: :car_ad_id
end