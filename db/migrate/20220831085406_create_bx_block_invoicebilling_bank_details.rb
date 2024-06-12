class CreateBxBlockInvoicebillingBankDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_details do |t|
      t.string :fze_bank_name
      t.string :emirates_nbd_swift
      t.string :euro_account_name
      t.string :account_no
      t.string :iban

      t.timestamps
    end
  end
end
