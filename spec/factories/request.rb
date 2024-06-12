FactoryBot.define do
  factory :request, class: 'BxBlockRequestManagement::Request' do
    association :account, factory: :account
    association :sender, factory: :account
    status { nil }
  end
end