FactoryBot.define do
  factory :service, class: 'BxBlockServices::Service' do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    logo { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'myfiles', 'bmw.jpeg'), 'image/jpeg') }
  end
end