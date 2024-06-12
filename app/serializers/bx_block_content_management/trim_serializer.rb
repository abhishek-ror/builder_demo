class BxBlockContentManagement::TrimSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :model
end
