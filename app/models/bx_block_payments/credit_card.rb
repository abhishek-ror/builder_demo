module BxBlockPayments
	class CreditCard < ApplicationRecord
		self.table_name = :credit_cards

		belongs_to :account, class_name: 'AccountBlock::Account', foreign_key: :account_id

		before_validation :set_last_digits

		attr_accessor :number, :cvc
		enum status: {'active': 0, 'inactive': 1}
		
		validates :digits, presence: true
  	validates :month, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  	validates :year, presence: true, numericality: { greater_than_or_equal_to: DateTime.now.year }

  	def set_last_digits
	    if number
	      number.to_s.gsub!(/\s/,'')
	      self.digits ||= number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1)
	    end
	  end
	end
end