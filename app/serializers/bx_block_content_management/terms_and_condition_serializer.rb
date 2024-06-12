module BxBlockContentManagement
  class TermsAndConditionSerializer < BuilderBase::BaseSerializer
    attributes :id, :description
    attribute :description_new do |object|
    ActionView::Base.full_sanitizer.sanitize(Nokogiri::HTML(object.description).text)
    end
  end
end
