module BxBlockPayments
	class PaymentTransaction < ApplicationRecord
		self.table_name = :payment_transactions
		include TransactionHelper

		belongs_to :account, class_name: 'AccountBlock::Account', foreign_key: :account_id

		enum status: {'inprogress': 0, 'completed': 1, 'failed': 2}

	end
end