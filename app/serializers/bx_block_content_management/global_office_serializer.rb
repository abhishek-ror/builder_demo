module BxBlockContentManagement
  class GlobalOfficeSerializer < BuilderBase::BaseSerializer
    attributes :id, :address_line_1, :address_line_2, :state, :city
    attribute :zipcode do |object|
      object.city.zipcode
    end
    attribute :country do |object|
      object.city.state.country.as_json.merge!({flag: object&.city&.state&.country&.image_url})
    end
  end
end
