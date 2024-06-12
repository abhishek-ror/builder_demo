FactoryBot.define do
    factory :black_list_user, class: AccountBlock::BlackListUser do
    association :account, factory: :account
  end
end