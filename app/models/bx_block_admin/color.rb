class BxBlockAdmin::Color < ApplicationRecord
  self.table_name = :colors
  has_and_belongs_to_many :car_ads
  validates :name, presence: true
end
