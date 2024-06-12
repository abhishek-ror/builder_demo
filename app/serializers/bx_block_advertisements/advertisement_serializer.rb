module BxBlockAdvertisements
  class AdvertisementSerializer
    include JSONAPI::Serializer
    attributes *[
      :id,
      :name,
      :description
    ]
    attributes :image do |object|
      object.image.attached? ? object.image.service_url : nil rescue nil
    end

  end
end
