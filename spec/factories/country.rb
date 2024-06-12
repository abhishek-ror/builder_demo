FactoryBot.define do
    factory :country, class: 'BxBlockAdmin::Country' do
      name{ 'India' }
      country_code{ '91' }
      region {association :region}
    end
  end