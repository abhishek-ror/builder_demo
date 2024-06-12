FactoryBot.define do
    factory :advertisement, class: 'BxBlockAdvertisement::Advertisement' do
      description { 'this is my new car i want to selling a car which is the best for you budger '}
      name{  'ad1'}
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'myfiles', 'bmw.jpeg'), 'image/jpeg') }
    end
  end