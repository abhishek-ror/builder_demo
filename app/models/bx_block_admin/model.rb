class BxBlockAdmin::Model < ApplicationRecord
  self.table_name = :models
  belongs_to :company
  has_many :trims, dependent: :destroy
  has_many :car_ads, through: :trims
  has_and_belongs_to_many :car_engine_types
  validates :name, presence: true, uniqueness: true
  before_create :set_car_body_type
  enum autopilot_type: {"No Driving Automation": 0, "Driver Assistance": 1, "Partial Driving Automation": 2, "Conditional Driving Automation": 3, "High Driving Automation": 4}
  def set_car_body_type
  	self.body_type = "Custom" if body_type = nil
  end
end
