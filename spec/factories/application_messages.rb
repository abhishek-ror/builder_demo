FactoryBot.define do
  factory :application_message, class: 'BxBlockLanguageOptions::ApplicationMessage' do
    name { 'test_key' }
    message { 'Test Message' }
  end
end