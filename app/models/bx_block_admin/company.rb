class BxBlockAdmin::Company < ApplicationRecord
	include ActiveStorageSupport::SupportForBase64
	self.table_name = :companies
	has_many :models, dependent: :destroy
	validates :name, presence: true, uniqueness: true
  validates :logo, presence: true
	has_one_attached :logo

    def logo_url
      if logo.attached?
        logo.service_url&.split('?')&.first
      else
        "#{ActiveStorage::Current.host}/images/missing.jpg"
      end
    end
end
