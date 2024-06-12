FactoryBot.define do
  factory :profile, class: 'BxBlockProfile::Profile' do
    country { 'USA' }
    address { '123 Main St' }
    city { 'New York' }
    postal_code { '12345' }
    association :account, factory: :account
  end
end