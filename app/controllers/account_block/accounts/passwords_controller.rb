module AccountBlock
  	module Accounts
  		class PasswordsController < ApplicationController
	    	def create 
		      	header_token = request.headers[:token]
		      	if header_token.present?
			        begin
			          token = BuilderJsonWebToken.decode(header_token)
			        rescue JWT::DecodeError => e
			          return render json: {
			            errors: [{
			              token: 'Invalid token',
			            }],
			          }, status: :bad_request
			        end
			        # Check new password requirements
			        password_validation = AccountBlock::PasswordValidation.new(create_params[:new_password])
			        is_valid = password_validation.valid?
			        # error_message = password_validation.errors.full_messages.first
			        error_message = "Password should be a minimum of 8 characters long,one uppercase,lowercase characters,one digit & one special character"
			        unless is_valid
			          return render json: {
			              errors: [{
			                password: error_message,
			              }],
			            }, status: :unprocessable_entity
			        else
			          @account = AccountBlock::Account.find(token.id)
			          	if @account.present?
				            if create_params[:new_password] == create_params[:confirm_password]
				              @account.update(password: create_params[:new_password],activated: true)
				              @account.update(temporary_token: "")
				              serializer = AccountBlock::AccountSerializer.new(@account)
				                serialized_account = serializer.serializable_hash
				                render json: {
				                				Account: serialized_account, 
				                				message: 'Password created successfully', 
				                	            meta: {
                      									token: encoded_token
                									},
                    							status: :created
                    						}
				            else
				              return render json: { errors: [{ message: 'Password not matched'}]}, status: :unprocessable_entity
				            end
				        else
				            return render json: {
				              errors: [{
				                msg: 'Account not found',
				              }],
				            }, status: :unprocessable_entity
				        end
			        end
			    else
			        return render json: {  errors: 'Token is required', status: :unprocessable_entity}
			    end
	   		end

	   		def user_one_time_password
	   			header_token = request.headers[:token]
	   			if header_token.present?
	   				begin
	   					token = BuilderJsonWebToken.decode(header_token)
	   				rescue JWT::DecodeError => e
	   					return render json: {
	   						errors: [{
	   							token: 'Invalid token',
	   						}],
	   					}, status: :bad_request
	   				end

		   			@account = AccountBlock::Account.find(token.id)
		   			if @account.present?
		   				if	@account.temporary_token == params[:temporary_token]
		   					return render json: {  message: 'Password can be created.', status: 200}
		   				else
		   					return render json: {  message: 'Link Expired'},status: 400
		   				end
		   			else
		   				return render json: {
		   					errors: [{
		   						msg: 'Account not found',
		   					}],
		   				}, status: :unprocessable_entity
		   			end
		   		else
		   			return render json: {  errors: 'Token is required', status: :unprocessable_entity}
		   		end			     		
		   	end

	    	private

	    	def encoded_token
      			BuilderJsonWebToken.encode @account.id, 1.months.from_now
    		end

		    def create_params
		      params.require(:data)
		        .permit(*[
		          :email,
		          :full_phone_number,
		          :token,
		          :otp_code,
		          :new_password,
		          :confirm_password
		        ])
		    end
  		end
	end
end
