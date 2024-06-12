module BxBlockShipment
	class UserReview < ApplicationRecord
		self.table_name = :shipment_user_reviews
		
		belongs_to :account, class_name: 'AccountBlock::Account'
		belongs_to :shipment, class_name: 'BxBlockShipment::Shipment'
		
	end
end
