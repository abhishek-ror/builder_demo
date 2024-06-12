module BxBlockRateCard
	class DestinationHandlingsController < ApplicationController
		# include BuilderJsonWebToken::JsonWebTokenValidation


		def create
			handling_charges = BxBlockRateCard::DestinationHandling.create(create_params)
      if handling_charges.save      
        render json: BxBlockRateCards::DestinationHandlingSerializer.new(handling_charges).serializable_hash,
               status: :ok
      else
        render json: format_activerecord_errors(handling_charges.errors),status: :unprocessable_entity
      end
		end

		def get_all_handling_charges
    	handling_charges = BxBlockRateCard::DestinationHandling.where(destination_country: get_params[:destination_country]) 
    	if handling_charges.present?
				render json: { handling_charges: BxBlockRateCards::DestinationHandlingSerializer.new(handling_charges).serializable_hash,status: :ok }  			
	    else 
					render json: {
													handling_charges: 
											    		{
											    		destination_country: "#{get_params[:destination_country]}",
											    		message:  "Data Not Available"
											    	}
	    									}
	    end
		end

		def get_all_source_country
			all_source_country = []
			source_countries = BxBlockRateCard::DestinationHandling.all
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
			countries = BxBlockRateCard::DestinationHandling.all
			if countries.present?
				countries.each do |country|
					destination_countries << {destination_country: country.destination_country} if country.destination_country.present? && !destination_countries.include?({destination_country: country.destination_country})
				end
				render json: {all_destination_countries: destination_countries, total: destination_countries.count}
			else
				render json: {
					message: "Destination_countries are not available"
				}
			end

		end


		private

		def create_params
	    	params.require(:data).permit(:destination_country,:unloading,:customs_clearance,:storage)
	  end
   	def get_params
    	params.require(:data).permit(:destination_country)
    end

	end
end
