module BxBlockAdmin
  class GlobalOffice < BxBlockAdmin::ApplicationRecord
    self.table_name = :global_offices
    belongs_to :city, class_name: "BxBlockAdmin::City"
    delegate :state, :to => :city
    delegate :country, :to => :state
    validates :address_line_1, :address_line_2, presence: true
  end
end
