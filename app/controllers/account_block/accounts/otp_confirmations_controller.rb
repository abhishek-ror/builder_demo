module AccountBlock
	module Accounts
		class OtpConfirmationsController < ApplicationController
		  def create
	      header_token = request.headers[:token]
	      if header_token.present? && params[:otp].present?
	        # Try to decode token with OTP information
	        begin
	          token = BuilderJsonWebToken.decode(header_token)
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
	          account = AccountBlock::Account.find(token.id)
	         if account.present?
	         	otp = AccountBlock::EmailOtp.find_by(email: account.email) 
	         else
	         	render json: {error: "Account not found"}
	         end
	        rescue ActiveRecord::RecordNotFound => e
	          return render json: {
	            errors: [{
	              otp: 'Token invalid',
	            }],
	          }, status: :unprocessable_entity
	        end

	        # Check OTP code
	        if otp.present?
		        if otp.pin == params[:otp].to_i
		          # otp.activated = true
		          # otp.save
		          otp.destroy
		          render json: {
		            messages: [{
		              otp: 'OTP validation success',
		            }],
		          }, status: :created
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
	            otp: 'OTP Not Found',
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

	    # def otp_params
	    #   params.require(:data)
	    #     .permit(*[
	    #       :email,
	    #       :full_phone_number,
	    #       :token,
	    #       :otp,
	    #       :new_password,
	    #     ])
	    # end
		end
	end

end
