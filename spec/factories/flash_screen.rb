FactoryBot.define do
  factory :flash_screen, class: 'BxBlockAdmin::FlashScreen' do
    screen_type{ 1 }
    title{'xyz'}
    description{ 'this is my new car i want to selling a car which is the best for you budger '}
    offer{ 'abc' }
    tips_for_advertisment_posting{ 'cars'}
    offer_title{'car'}
    tips_title{'car_ads'}
    description_title{'car_advertisement'}
  end
end
