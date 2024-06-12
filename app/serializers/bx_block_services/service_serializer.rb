module BxBlockServices
    class ServiceSerializer
      include JSONAPI::Serializer
      attributes :id, :title, :description, :logo

      attribute :logo do |object|
        object.logo_url
      end
    end
  end
  