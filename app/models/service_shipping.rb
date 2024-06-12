class ServiceShipping < ApplicationRecord
self.table_name = :service_shippings

has_many :vehicle_shippings, class_name: 'BxBlockVehicleShipping::VehicleShipping', dependent: :destroy, foreign_key: :service_shippings_id
validate :title_must_be_valid
private
  def title_must_be_valid
    errors.add(:title, 'enter valid title') if title.blank?
  end
end