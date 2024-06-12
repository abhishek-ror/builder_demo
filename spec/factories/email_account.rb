FactoryBot.define do
  factory :email_account, class: AccountBlock::EmailAccount do
    email { "test@example.com" }

  end
end
