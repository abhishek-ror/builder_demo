FactoryBot.define do
  factory :state, class: 'BxBlockAdmin::State' do
    name{ 'Maharashtra' }
    country {association :country}
  end
end
