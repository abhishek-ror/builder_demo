class BxBlockAdmin::Banner < ApplicationRecord
  self.table_name = :banners
  has_one :image, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  accepts_nested_attributes_for :image
end
