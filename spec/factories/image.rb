include ActionDispatch::TestProcess
FactoryBot.define do
  factory :image, class: 'BxBlockContentManagement::Image' do
    image{ Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'myfiles', 'bmw.jpeg')) }
  end
end
