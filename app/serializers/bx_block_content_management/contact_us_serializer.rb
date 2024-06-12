module BxBlockContentManagement
  class ContactUsSerializer < BuilderBase::BaseSerializer
    attributes :id, :description, :email, :name
  end
end
