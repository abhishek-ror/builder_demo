FactoryBot.define do
  factory :contact_us, class: 'BxBlockAdmin::ContactUs' do
    description{ 'this is my new car i want to selling a car which is the best for you budger '}
    email{ 'test1@gmail.com '}
    name{ 'test' }
  end
end
