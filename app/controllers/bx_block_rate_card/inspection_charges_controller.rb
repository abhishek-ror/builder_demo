module BxBlockRateCard
	class InspectionChargesController < ApplicationController
		include BuilderJsonWebToken::JsonWebTokenValidation
		# before_action :validate_json_web_token

	    def create
	      inspection_info = BxBlockRateCard::InspectionCharge.create(create_params)
	      if inspection_info.save      
	        render json: BxBlockRateCards::InspectionChargeSerializer.new(inspection_info).serializable_hash,
	               status: :ok
	      else
	        render json: format_activerecord_errors(inspaction_info.errors),status: :unprocessable_entity
	      end
	    end

	    def get_inspection_charges
	    	data = []
	    	inspaction_charges = BxBlockRateCard::InspectionCharge.find_by('lower(country) = ?', get_params[:country].downcase)
		    	if inspaction_charges.present?
		    		data <<  BxBlockRateCards::InspectionChargeSerializer.new(inspaction_charges)			
			    else 
			    	data << { data: 
			    		{
			    		Country: "#{get_params[:country]}",
			    		Message:  "Data Not Available"
			    	}
			    }
			    end
			# end
			render json: {inspection_charges: data}
		end

		def get_all_country
			all_country = []
			countries = BxBlockRateCard::InspectionCharge.all
			if countries.present?
				countries.each do |country|
					all_country << {country: country.country}if country.country.present? && !all_country.include?({country: country.country})
				end
				render json: {all_countries: all_country, total: all_country.count}
			else
				render json: {
					message: "countries are not available"
				}
			end
		end

		def get_all_region
			all_region = []
			countries = BxBlockRateCard::InspectionCharge.where(country: params[:country])
			if countries.present?
				countries.each do |country|
					all_region << {region: country.region} if country.region.present?
				end
				render json: {all_region: all_region, total: all_region.count}
			else
				render json: {
					message: "Regions are not available"
				}
			end
		end

		# def import_csv
		# 	begin
		# 		BxBlockRateCard::InspectionCharge.import(params[:file])
		# 		render json: {message: "File imported successfully.."}
		# 	rescue Exception => e
		# 		render json: {
		#           error: { message: e.message}
		#         }, status: :internal_server_error
		# 	end
		# end

		# def export_csv_or_xls
		# 	@inspaction_charge_data = BxBlockRateCard::InspectionCharge.all
		# 	respond_to do |format|			
		# 		format.html
		# 		format.csv {send_data @inspaction_charge_data.export_to_csv(@inspaction_charge_data, [ 'country','region','price']), filename: "inspaction_charge-#{Date.today}.csv" }
		# 		format.xls {send_data @inspaction_charge_data.export_to_csv(@inspaction_charge_data, [ 'country','region','price']),col_sep: "\t",filename: "inspaction_charge-#{Date.today}.xls"}
		# 	end
		# end


	    # def update
	    #   @inspaction_charge = BxBlockRateCard::InspectionCharge.where(country: update_params[:country])
	    #   if @inspaction_charge.present?
	    #     if @inspaction_charge.update(update_params)
	    #       render json: BxBlockRateCards::InspectionChargeSerializer.new(@inspaction_charge, meta: {
	    #         message: 'Address Updated Successfully',
	    #       }).serializable_hash, status: :ok
	    #     else
	    #       render json: { errors: format_activerecord_errors(@inspaction_charge.errors) },
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
	    	params.require(:data).permit(:country,:region)
	    end
	end
end
