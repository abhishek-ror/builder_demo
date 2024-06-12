class BxBlockAdmin::Trim < ApplicationRecord
  self.table_name = :trims
  belongs_to :model
  has_many :car_ads, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
