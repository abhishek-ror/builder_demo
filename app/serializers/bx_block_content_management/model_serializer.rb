class BxBlockContentManagement::ModelSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :company
end
