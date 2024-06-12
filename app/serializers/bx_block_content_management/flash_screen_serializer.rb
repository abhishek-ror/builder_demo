class BxBlockContentManagement::FlashScreenSerializer
  include JSONAPI::Serializer
  attributes :id, :screen_type, :images, :description, :offer_title, :tips_title, :offer, :tips_for_advertisment_posting, :description_title

  attribute :offer_new do |object|
    ActionView::Base.full_sanitizer.sanitize(Nokogiri::HTML(object.offer).text)
  end

  attribute :description_new do |object|
    ActionView::Base.full_sanitizer.sanitize(Nokogiri::HTML(object.description).text)
  end
  
  attribute :tips_for_advertisment_posting_new do |object|
    content = object.tips_for_advertisment_posting
    doc = Nokogiri::HTML(content)
    paragraphs = doc.css('p').map(&:content)
    paragraphs.reject(&:empty?)
  end
  
end
