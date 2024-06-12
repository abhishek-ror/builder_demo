FactoryBot.define do
  factory :bank_detail, class: 'BxBlockInvoicebilling::BankDetail' do
    fze_bank_name { "Bank Name" }
    emirates_nbd_swift { "test" }
    euro_account_name { "demo" }
    account_no { "123456789" }
    iban { "test123" }
  end
end