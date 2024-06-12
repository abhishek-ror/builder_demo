class BxBlockAdmin::FlashScreen < ApplicationRecord
	self.table_name = :flash_screens
	validates :screen_type, :title, :description, :offer, :tips_for_advertisment_posting, :offer_title, :tips_title, :description_title, presence: true
	
	#enum screen_type: ['buy', 'sell', 'inspection', 'shipping']
	enum screen_type: {"buy":0, "sell":1, "inspection":2, "shipping":3}
	has_many :images, as: :attached_item, class_name: 'BxBlockContentManagement::Image'

	accepts_nested_attributes_for :images
	
end
