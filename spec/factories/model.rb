FactoryBot.define do
    factory :model, class: 'BxBlockAdmin::Model' do
      name{ "BMW#{rand(1000)}" }
      body_type{ 'Custom' }
      engine_type{ 'Automatic Transmission' }
      autopilot{ true }
      company {association :company}
    end
  end