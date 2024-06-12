 module BxBlockVehicleShipping
	class VehicleSellingsController < ApplicationController
		include BuilderJsonWebToken::JsonWebTokenValidation
		before_action :validate_json_web_token, except: :vehicle_without_token
		before_action :current_user, except: :vehicle_without_token

    def create
    	selling = BxBlockVehicleShipping::VehicleSelling.new(selling_params)
    	selling.account_id = current_user.id
    	if selling.save
			handle_create_images(selling)
    		email_otp = AccountBlock::EmailOtp.new(email: current_user.email)
    		if email_otp.save
          send_email_for(email_otp, current_user)
          token = token_for(email_otp, selling.id)
          render json: { 
	    			Message: "OTP has been send to your registraed email.",
	    			vehicle_selling:{
	    				otp: email_otp.pin,
	    				token: token
	    			}
	    		},status: 200  
        else
          render json: {
            errors: [email_otp.errors],
          }, status: :unprocessable_entity
        end
    	else
    		render json: {errors: format_activerecord_errors(selling.errors)},status: :unprocessable_entity
    	end
    end
    
    def vehicle_selling
      @vehicle_sellings = current_user.vehicle_sellings.where(verified:true).page(params[:page]).per(params[:per_page])
      @all_selling = []
      @vehicle_sellings.each do |object|
       @images = object&.images.as_json(only: [:id, :image])
       @all_selling  << object.as_json().merge(images:@images,user:object.account,sold_at: object.status == "sold" ? object.updated_at :  "")
      end
      render json: { total_pages: @vehicle_sellings.total_pages, vehicle_selling:@all_selling }, status: :ok
    end

    def destroy
      @ads = BxBlockVehicleShipping::VehicleSelling.find_by_id(params[:id])
      if @ads.present?
         @ads.destroy
          render json: {selling: "Ads deleted successfully"},status: 200
      else
        render json: {selling: "No ads found!"},status: 404
      end
    end 

    def index
      page = params[:page].to_i.positive? ? params[:page].to_i : 1
      per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10

      selling = BxBlockVehicleShipping::VehicleSelling.all.where(approved_by_admin: true).order(created_at: :desc) 
      total_cars = selling.count

      total_pages = (total_cars.to_f / per_page).ceil

      if page > total_pages
        render json: { error: "Invalid page number. Page does not exist." }, status: :unprocessable_entity
        return
      end

      paginated_selling = selling.page(page).per(per_page)

      if paginated_selling.any?
        render json: {
          AllSellingData: BxBlockVehicleShippings::VehicleSellingSerializer.new(paginated_selling, params: { current_user_id: current_user&.id }).serializable_hash,
          total_cars: total_cars,
          total_pages: total_pages
        }, status: 200
      else
        render json: { selling: "Selling not found" }, status: :not_found
      end
    end


    def show
      selling = BxBlockVehicleShipping::VehicleSelling.find_by(id: params[:id])
      return render json: {SellingData: BxBlockVehicleShippings::VehicleSellingSerializer.new(selling, params: {current_user_id: current_user.id}).serializable_hash}, status: 200 if selling.present?
        render json: {selling: "selling not Found"}, status: :not_found if selling.blank?
    end

    def vehicle_without_token
      selling = BxBlockVehicleShipping::VehicleSelling.find_by(id: params[:id])
      return render json: {SellingData: BxBlockVehicleShippings::VehicleSellingSerializer.new(selling).serializable_hash}, status: 200 if selling.present?
        render json: {selling: "selling not Found"}, status: :not_found if selling.blank?
    end

    def update
      selling = BxBlockVehicleShipping::VehicleSelling.find_by(id: params[:id])
      if selling.present? 
        if selling.update(selling_edit_params)
          handle_create_images(selling)
          render json: {message: "List Updated", shipment: BxBlockVehicleShippings::VehicleSellingSerializer.new(selling, params: {current_user_id: current_user.id}).serializable_hash}
        else
          render json: {errors: format_activerecord_errors(selling.errors)},status: :unprocessable_entity
        end
      else
        render json: {errors: "Record Not Found"},status: :unprocessable_entity
      end
    end

    def varify
      if otp_params['selling_token'].blank?
        return render json: {
          errors: [{
            token: "Token can't be blank",
          }],
        }, status: :unprocessable_entity
      end

      if otp_params['selling_token'].present? && otp_params['otp_code'].present?
        # Try to decode token with OTP information
        begin
          token = BuilderJsonWebToken.decode(otp_params['selling_token'])
          vehicle_selling = BxBlockVehicleShipping::VehicleSelling.find(token.selling_id)
        rescue JWT::ExpiredSignature
          return render json: {
            errors: [{
              pin: 'OTP has expired, please request a new one.',
            }],
          }, status: :unauthorized
        rescue JWT::DecodeError => e
          return render json: {
            errors: [{
              token: 'Invalid token',
            }],
          }, status: :bad_request
        end

        # Try to get OTP object from token
        begin
          otp = token.type.constantize.find(token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {
            errors: [{
              otp: 'Token invalid',
            }],
          }, status: :unprocessable_entity
        end

        # Check OTP code
        if otp_params['otp_code'].to_s.count("a-zA-Z") > 0
          return render json: {
            errors: [{
              otp: 'OTP must be a number',
            }],
          }, status: :unprocessable_entity
        end
        
        if otp.pin == otp_params['otp_code'].to_i
          otp.activated = true
          otp.save
          vehicle_selling.update(verified: true)
          render json: { 
	    			Message: "OTP varification successfully",
	    			shipment: BxBlockVehicleShippings::VehicleSellingSerializer.new(vehicle_selling, params: {current_user_id: current_user.id}).serializable_hash
	    		},status: 200
        else
          return render json: {
            errors: [{
              otp: 'Invalid OTP code',
            }],
          }, status: :unprocessable_entity
        end
      else
        return render json: {
          errors: [{
            otp: 'Token and OTP code are required',
          }],
        }, status: :unprocessable_entity
      end
    end

    private 

    def selling_params
    	 params.require(:vehicle_selling).permit(:city_id, :account_id, :trim_id, :region_id, 
    		:country_id, :state_id, 
    		:year, :model, :regional_spec, :kms, :body_type, :body_color,
    		:seller_type, :engine_type, :steering_side, :badges, :about_car, 
    		:features, :make, :no_of_doors, :transmission, :price, :warranty, :no_of_cylinder,
    		:horse_power, :contact_number, :about_car, :tracking_status, images_attributes: [:id, :image, :item_type]
			)
    end

    def selling_edit_params
       params.require(:vehicle_selling).permit(:id, :city_id, :account_id, :admin_user_id, :trim_id, :region_id, 
        :country_id, :state_id, 
        :year, :model, :regional_spec, :kms, :body_type, :body_color,
        :seller_type, :engine_type, :steering_side, :badges, 
        :features, :make, :no_of_doors, :transmission, :price, :warranty, :no_of_cylinder,
        :horse_power, :contact_number, images_attributes: [:id, :image, :item_type]
      )
    end

    def otp_params
    	params.require(:data)[:attributes].permit(:otp_code,:selling_token)
    end

    def send_email_for(otp_record, account)
      BxBlockForgotPassword::EmailOtpMailer
        .with(otp: otp_record, host: request.base_url, user_name: current_user&.first_name)
        .otp_email.deliver
    end

    def token_for(otp_record, selling_id)
      BuilderJsonWebToken.encode(
        otp_record.id,
        5.minutes.from_now,
        type: otp_record.class,
        selling_id: selling_id
      )
    end

  	def handle_create_images(data)
  		if params["vehicle_selling"]["image_attributes"].present?
  		  params["vehicle_selling"]["image_attributes"]["images"]&.each do |image|
  			data.images.create(:image=> image)
  		  end
  		end
  	end
	end
  
end
