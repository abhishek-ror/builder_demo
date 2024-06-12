class BxBlockAdmin::Extra < ApplicationRecord
  self.table_name = :extras
  has_and_belongs_to_many :car_ads
  validates :name, presence: true
end



