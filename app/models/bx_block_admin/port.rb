module BxBlockAdmin
  class Port < BxBlockAdmin::ApplicationRecord
    self.table_name = :ports
    belongs_to :country
  end
end