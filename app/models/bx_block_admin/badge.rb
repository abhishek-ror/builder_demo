class BxBlockAdmin::Badge < ApplicationRecord
  self.table_name = :badges
  has_and_belongs_to_many :car_ads
  validates :name, presence: true
end
