module BxBlockInvoicebilling
	class BankDetail < ApplicationRecord
		self.table_name = :bank_details
		     validates :account_no, presence: true, numericality: { only_integer: true }, length: { minimum: 1, maximum: 20 }
		     validates :fze_bank_name, :emirates_nbd_swift, :euro_account_name, :iban, presence: true

	end
end