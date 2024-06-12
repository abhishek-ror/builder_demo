class BxBlockAdmin::SellerType < ApplicationRecord
  self.table_name = :seller_types
  has_and_belongs_to_many :car_ads
  validates :name, presence: true
end
