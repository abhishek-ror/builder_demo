module BxBlockAdmin
  class State < BxBlockAdmin::ApplicationRecord
    self.table_name = :states
    belongs_to :country
    has_many :cities
    validates :name, presence: true, format: { with: /\A([A-Z]{1}[a-z]*\s*)*\z/, message: "State name can't start with LowerCase"}
  end
end
