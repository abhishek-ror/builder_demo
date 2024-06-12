class BxBlockAdmin::RegionalSpec < ApplicationRecord
  self.table_name = :regional_specs
  has_and_belongs_to_many :car_ads
  validates :name, presence: true
end
