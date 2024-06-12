FactoryBot.define do
    factory :city, class: 'BxBlockAdmin::City' do
      name { 'Indore' }
      state {association :state}
    end
  end
