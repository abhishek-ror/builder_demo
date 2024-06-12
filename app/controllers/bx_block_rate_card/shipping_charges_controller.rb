module BxBlockRateCard
	class ShippingChargesController < ApplicationController
		include BuilderJsonWebToken::JsonWebTokenValidation
		# before_action :validate_json_web_token

		def create
	      shipping_info = BxBlockRateCard::ShippingCharge.create(create_params)
	      if shipping_info.save      
	        render json: BxBlockRateCards::ShippingChargeSerializer.new(shipping_info).serializable_hash,
	               status: :ok
	      else
	        render json: format_activerecord_errors(shipping_info.errors),status: :unprocessable_entity
	      end
	  end

    def get_shipping_charges
    	data = []
    	destination_countries = get_params[:destination_country].split(",")
    	destination_countries.each do |destination_country|
	    	shipping_charges = BxBlockRateCard::ShippingCharge.where(source_country: get_params[:source_country],destination_country: destination_country) 
	    	if shipping_charges.present?
	    		shipping_charges.each do |shipping_charge|
	    			data <<  BxBlockRateCards::ShippingChargeSerializer.new(shipping_charge)	
	    		end	   			
		    else 
		    	data << { data: 
		    		{
		    		source_country: "#{get_params[:source_country]}",
		    		destination_country: "#{destination_country}",
		    		Message:  "Data Not Available"
		    	}
		    }
		    end
			end
			render json: {shipping_charges: data}
    end

    def get_all_source_country
			all_source_country = []
			source_countries = BxBlockRateCard::ShippingCharge.all
			if source_countries.present?
				source_countries.each do |country|
					all_source_country << {source_country: country.source_country} if country.source_country.present? && !all_source_country.include?({source_country: country.source_country})
				end
				render json: {all_source_countries: all_source_country, total: all_source_country.count}
			else
				render json: {
					message: "source_country are not available"
				}
			end
		end

		def get_all_destination_country
			destination_countries = []
			source_countries = BxBlockRateCard::ShippingCharge.all
			if source_countries.present?
				source_countries.each do |country|
					destination_countries << {destination_country: country.destination_country} if country.destination_country.present? && !destination_countries.include?({destination_country: country.destination_country})
				end
				render json: {all_destination_countries: destination_countries, total: destination_countries.count}
			else
				render json: {
					message: "Destination_countries are not available"
				}
			end
		end

		def check_price_availability
	    source_country = params[:source_country]
	    destination_country = params[:destination_country]
	    destination_port = params[:destination_port]

	    shipping_charge = ShippingCharge.find_by(
	      source_country: source_country,
	      destination_country: destination_country,
	      destination_port: destination_port
	    )
	    if shipping_charge
	      render json: { available: true, price: shipping_charge.price }
	    else
	      render json: { available: false, message: 'The selected port is not available.' }
	    end
	  end

    private 

    def create_params
    	params.require(:data).permit(:source_country,:destination_country,:destination_port,:price,:in_transit)
    end

    def get_params
    	params.require(:data).permit(:source_country, :destination_country)
    end
	end
end
