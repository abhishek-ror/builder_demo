module BxBlockAdvertisement
  class Advertisement < ApplicationRecord
  	include ActiveStorageSupport::SupportForBase64
  	self.table_name = :advertisements
  	validates :name, presence: true
		validates :description, presence: true
		validates :image, presence: true

  	has_one_attached :image
  end
end
