module AccountBlock
  module Accounts
    class EmailConfirmationsController < ApplicationController
      include BuilderJsonWebToken::JsonWebTokenValidation

      before_action :validate_json_web_token

      def show
        begin
          @account = EmailAccount.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {account: 'Account Not Found'},
          ]}, status: :unprocessable_entity
        end

        if @account.activated?
          return render json: ValidateAvailableSerializer.new(@account, meta: {
            message: 'Account already activated', status: :ok
          }).serializable_hash
        end

        @account.update(activated: true)

        @email_confirmation = @account

        # render json: ValidateAvailableSerializer.new(@account, meta: {
        #   message: 'Account Activated Successfully',status: :ok
        # }).serializable_hash
        render "account_block/accounts/email_confirmations/show.html.erb"
      end
    end
  end
end
