ActiveAdmin.register BxBlockInvoicebilling::BankDetail,as: "Bank Details" do

  permit_params :fze_bank_name, :emirates_nbd_swift, :euro_account_name, :account_no, :iban

  form do |f|
    f.inputs do
      f.input :fze_bank_name
      f.input :emirates_nbd_swift
      f.input :euro_account_name
      f.input :account_no, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");' }
      f.input :iban
    end
    f.actions
  end
 
  filter :fze_bank_name
end