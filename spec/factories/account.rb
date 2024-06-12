FactoryBot.define do
    factory :account, class: 'AccountBlock::Account' do
      first_name{ 'test1' }
      full_phone_number{ "91#{rand(6_000_000_000..9_999_999_999)}" }
      country_code{ 91 }
      phone_number{ 1234567890 }
      email{ 'test@gmail.com' }
      password_digest { 'rakesh123'}
      type{ 'EmailAccount' }
      user_type{ 'business' }
      status{ 'regular' }
      full_name{ 'test1' }
      country{ 'India' }
    end
end