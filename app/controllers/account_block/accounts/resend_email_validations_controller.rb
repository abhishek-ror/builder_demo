module AccountBlock
  module Accounts
    class ResendEmailValidationsController < ApplicationController
      def create
        # puts " - params = #{params}"
        # Check what type of account we are trying to recover
        json_params = jsonapi_deserialize(params)
        if json_params['email'].present?
          # Get account by email
          @account = AccountBlock::EmailAccount
            .where(
              "LOWER(email) = ?",
              json_params['email'].downcase
            ).first

          return render json: {
            errors: [{
              msg: 'Account not found',
            }],
          }, status: :not_found if @account.nil?
          if @account.present?
            # if @account.activated?
              EmailValidationMailer
              .with(account: @account, host: request.base_url)
              .activation_email.deliver_now 
              render json: {
                message: "Verification Link sent to your Email Successfully",
                meta: {
                        token: encoded_token
                      }
              }
            # else
            #  render json: {message: "Account is not verified please signup first"}
            # end
          else
            render json: {message: "Account is not present please signup first"}
          end

        else
          return render json: {
            errors: [{
              msg: 'Email required',
            }],
          }, status: :unprocessable_entity
        end
      end

      private 

      def encoded_token
        BuilderJsonWebToken.encode @account.id, 1.months.from_now
      end
    end
  end
end
