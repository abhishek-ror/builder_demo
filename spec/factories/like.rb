FactoryBot.define do
  factory :like, class: BxBlockLike::Like do
    association :likeable, factory: :some_likeable_association
    like_by { association(:account_block_account) }
  end
end