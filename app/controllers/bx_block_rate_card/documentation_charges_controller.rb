module BxBlockRateCard
	class DocumentationChargesController < ApplicationController
		include BuilderJsonWebToken::JsonWebTokenValidation

		# before_action :validate_json_web_token

	    def create
	      documentation_info = BxBlockRateCard::DocumentationCharge.create(create_params)
	      if documentation_info.save      
	        render json: BxBlockRateCards::DocumentationChargeSerializer.new(documentation_info).serializable_hash,
	               status: :ok
	      else
	        render json: format_activerecord_errors(documentation_info.errors),status: :unprocessable_entity
	      end
	    end

	    def get_documentation_charges
	    	data = []
	    	documentation_charges = BxBlockRateCard::DocumentationCharge.where(country: get_params[:country])
	    	if documentation_charges.present?
	    		documentation_charges.each do |documentation_charge|
	    			data <<  BxBlockRateCards::DocumentationChargeSerializer.new(documentation_charge)
	    		end
	    			
		    	render json: {documentation_charges: data}
		    else 
		    	render json: {
		    		message: "inspaction charges Not Found "
		    	}
		    end
		end

		def get_all_country
			all_country = []
			countries = BxBlockRateCard::DocumentationCharge.all
			if countries.present?
				countries.each do |country|
					# all_country << {country: country.country} if country.country.present?
					all_country << {country: country.country}if country.country.present? && !all_country.include?({country: country.country})

				end
				render json: {all_countries: all_country, total: all_country.count}
			else
				render json: {
					message: "countries are not available"
				}
			end
		end

		# def import_csv
		# 	begin
		# 		BxBlockRateCard::DocumentationCharge.import(params[:file])
		# 		render json: {message: "File imported successfully.."}
		# 	rescue Exception => e
		# 		render json: {
		#           error: { message: e.message}
		#         }, status: :internal_server_error
		# 	end
		# end

		# def export_csv_or_xls
		# 	@documentation_charge_data = BxBlockRateCard::DocumentationCharge.all
		# 	respond_to do |format|		
		# 		format.html
		# 		format.csv {send_data @documentation_charge_data.export_to_csv(@documentation_charge_data, [ 'country','region','price']),filename: "documentation_charge-#{Date.today}.csv" }

		# 		format.xls {send_data @documentation_charge_data.export_to_csv(@documentation_charge_data, [ 'country','region','price']),col_sep: "\t",filename: "documentation_charge-#{Date.today}.xls"}
		# 	end
		# end


	    # def update
	    #   @documentation_charge = BxBlockRateCard::DocumentationCharge.find(update_params[:id])
	    #   if @documentation_charge.present?
	    #     if @documentation_charge.update(update_params)
	    #       render json: BxBlockRateCards::DocumentationChargeSerializer.new(@documentation_charge, meta: {
	    #         message: 'Address Updated Successfully',
	    #       }).serializable_hash, status: :ok
	    #     else
	    #       render json: { errors: format_activerecord_errors(@documentation_charge.errors) },
	    #              status: :unprocessable_entity
	    #     end
	    #   else
	    #     render json: {msg: "inspaction_charge not found"}
	    #   end
	    # end



	    private 

	    def update_params
	    	params.require(:data).permit(:id,:country,:region,:price)
	    end

	    def create_params
	    	params.require(:data).permit(:country,:region,:price)
	    end

	    def get_params
	    	params.require(:data).permit(:country)
	    end
	end
end