class BxBlockAdmin::CarEngineType < ApplicationRecord
  self.table_name = :car_engine_types
  has_and_belongs_to_many :models
  has_and_belongs_to_many :car_ads
  validates :name, presence: true
end
