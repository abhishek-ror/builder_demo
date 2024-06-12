FactoryBot.define do
  factory :social_account, class: AccountBlock::SocialAccount do
    email { Faker::Internet.unique.email }
    unique_auth_id { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
  end
end