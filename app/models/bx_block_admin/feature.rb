class BxBlockAdmin::Feature < ApplicationRecord
  self.table_name = :features
  has_and_belongs_to_many :car_ads
  validates :name, presence: true
end
