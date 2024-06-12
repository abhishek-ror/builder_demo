module BxBlockRateCard
	class DestinationHandling < ApplicationRecord
		self.table_name = :destination_handlings
    	validates :destination_country, :uniqueness => {:scope => :source_country, :message => "Data already present.."}
    	validates :destination_country, presence: true,  format: { with: /\A\p{Lu}.*\z/, message: "Only String value is allow and first character should be capital."}
    	validates  :unloading, :customs_clearance, :storage, presence: true, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }
	end
end