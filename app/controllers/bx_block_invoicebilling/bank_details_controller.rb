module BxBlockInvoicebilling
	class BankDetailsController < ApplicationController

		def get_bank_details
			bank_details = BxBlockInvoicebilling::BankDetail.all.as_json
			if bank_details.present?
				render json: {bank_details: bank_details}
			else
				render json: {bank_details: "Details Not Found"}
			end
		end
	end
end
