FactoryBot.define do
    factory :admin_user, class: "AdminUser" do
      email { "admin+2@example.com" }
      password { 'password' }
      password_confirmation { "password" }
    end
end