module BxBlockAdmin
  class City < BxBlockAdmin::ApplicationRecord
    self.table_name = :cities
    belongs_to :state
    validates :name, presence: true, format: { with: /\A([A-Z]{1}[a-z]*\s*)*\z/, message: "City name can't start with LowerCase"}
  end
end
