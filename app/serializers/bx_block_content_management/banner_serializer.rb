module BxBlockContentManagement
  class BannerSerializer < BuilderBase::BaseSerializer
    attributes :id, :priority, :image
  end
end
