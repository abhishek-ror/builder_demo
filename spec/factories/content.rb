# Assuming you have a "content" factory file (e.g., content.rb) in the appropriate directory

FactoryBot.define do
  factory :content, class: 'BxBlockContentManagement::Content' do
    # Replace `attribute_name` with the actual attribute names and provide appropriate values

    status { 'pending' }
    # bio { 'Sample bio' }
    archived { 'false' }
    feature_article { 'false' }
    feature_video { 'false' }
    review_status { 'pending' }
    feedback { 'test' }
        

    # association :image, factory: :image

  end
end
