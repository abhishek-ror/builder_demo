module BxBlockLogin
	class LogoutsController < ApplicationController
		include BuilderJsonWebToken::JsonWebTokenValidation
   		before_action :validate_json_web_token, :current_user

	    def destroy
	    	header_token = request.headers[:token]
		      if header_token.present?
		        begin
		          @token = BuilderJsonWebToken.decode(header_token)
		          token = encoded_token
	      			render json: {meta: {
	      					message: "Logout Successfully..",
			            account: AccountBlock::AccountSerializer.new(@current_user),
			            token: token,

			          }}

		        rescue JWT::DecodeError => e
		          return render json: {
		            errors: [{
		              token: 'Invalid token',
		            }],
		          }, status: :bad_request
		        end
		      else
	     			render json: {message: "Token Required"}
		      end
	    end

	    private

    	def encoded_token
    		BuilderJsonWebToken.encode @token.id, Time.now
  		end

  		def current_user
      	@current_user ||= AccountBlock::Account.find(@token.id) if @token.present?
    	end
	end
end
