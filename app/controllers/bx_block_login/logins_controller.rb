module BxBlockLogin
  class LoginsController < ApplicationController
    def create
      case params[:data][:type] #### rescue invalid API format
      when 'sms_account', 'email_account', 'social_account'
        account = OpenStruct.new(jsonapi_deserialize(params))
        account.type = params[:data][:type] 

        output = AccountAdapter.new

        output.on(:account_not_found) do |account|
          render json: {
            errors: [{
              failed_login: 'Account not found or not activated please check your e-mail.',
            }],
          }, status: :unprocessable_entity
        end

        output.on(:failed_login) do |account|
          render json: {
            errors: [{
              failed_login: 'Your password is incorrect',
            }],
          }, status: :unauthorized
        end

        output.on(:successful_login) do |account, token, refresh_token|
          account.update(fcm_device_token: params[:data][:attributes][:fcm_device_token])
          render json: {meta: {
            account: account,
            token: token,
            refresh_token: refresh_token
          }}
          account.update(temp_car_ad_id: nil)
        end

        output.login_account(account)
      else
        render json: {
          errors: [{
            account: 'Invalid Account Type',
          }],
        }, status: :unprocessable_entity
      end
    end
  end
end
