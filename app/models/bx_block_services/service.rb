module BxBlockServices
  class Service < ApplicationRecord
    include ActiveStorageSupport::SupportForBase64
    validates :title, presence: true
    validates :description, presence: true
    has_one_attached :logo

    def logo_url
      if logo.attached?
        logo.service_url&.split('?')&.first
      else
        "#{ActiveStorage::Current.host}/images/missing.jpg"
      end
    end
  end
end
