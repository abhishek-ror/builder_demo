module StripePaymentLink
	extend ActiveSupport::Concern

	# Stripe Payment Link Generation method.
	def generate_payment_link(name, amount, metadata={})
		begin
			service = BxBlockPayments::StripeIntegrationService.new
			product = BxBlockAdmin::StripeProduct.find_by(name: name)
			
			if product.blank?
				product_res = service.create_product(name)
				
				if service.errors.blank? && product_res.present? && product_res&.id.present?
					BxBlockAdmin::StripeProduct.create!(name: name, product_id: product_res&.id)
					create_payment_link(amount, product_res&.id, metadata)
				end
			else
				create_payment_link(amount, product.product_id, metadata)
			end
		rescue Exception => e
			Rails.logger.info "Stripe Payment Link Generation: #{e.message}"
			return nil
		end
	end

	def update_payment_link(id, active)
		service = BxBlockPayments::StripeIntegrationService.new
		res = service.update_payment_link(id,active)
	end

	private

	def create_payment_link(amount, product_id, metadata)
		service = BxBlockPayments::StripeIntegrationService.new
		price_res = service.create_price(amount, product_id)
		if price_res.present? && price_res&.id.present?
			link_response = service.create_payment_link(price_res&.id, metadata)
			service.errors.present? ? nil : link_response
		end
	end

end