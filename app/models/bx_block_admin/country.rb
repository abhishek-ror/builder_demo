module BxBlockAdmin
  class Country < BxBlockAdmin::ApplicationRecord
    self.table_name = :countries
    belongs_to :region
    has_many :states
    has_one_attached :file
    has_many :ports
    validates :country_code, presence: true

    #validates :region_id, presence: true
    validates :name, presence: true,format: { with: /\A([A-Z]{1}[a-z]*\s*)*\z/, message: "Country name can't start with LowerCase"}
    def image_url
      return '' unless file.attached?
      file.service.send(:object_for, file.blob.key).public_url
    end
  end
end
