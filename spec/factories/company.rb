include ActionDispatch::TestProcess
FactoryBot.define do
  factory :company, class: 'BxBlockAdmin::Company' do
    name { "name#{rand(1000)}" }
    logo { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'myfiles', 'bmw.jpeg'), 'image/jpeg') }
  end
end