module BxBlockAdmin
  class Region < BxBlockAdmin::ApplicationRecord
    self.table_name = :regions
    has_many :countries
    has_one :image, as: :attached_item, class_name: 'BxBlockContentManagement::Image'#, required: true
    validates :name, presence: true, format: { with: /\A([A-Z]{1}[a-z]*\s*)*\z/, message: "Region name can't start with LowerCase"}
    accepts_nested_attributes_for :countries, :allow_destroy => true
    accepts_nested_attributes_for :image, :allow_destroy => true

    def image_url
      data = image.as_json(only: [:image])
      data['image']['url'] if data.present? && data['image'].present?
    end
  end
end