module AccountBlock
  class AccountsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, only: [:search, :get_term_and_condition, :update_term_and_condition, :delete_account]

    def create
      account_params = user_params

      return render json: {status: 400, message: 'Email/Phone number is mandatory'} if account_params[:email].blank? && account_params[:phone_number].blank?

      object_key = ["phone_number", "email", 'country_code'] 
      object_key.each do|data|
        return render json: { status: 401, message: data.titleize + " Should not be blank", data: []} if account_params[data].blank?
      end

      account = AccountBlock::Account.where('LOWER(email) = ? or phone_number=?', account_params[:email].downcase, account_params[:phone_number]).first
      return render json: {status: 400, message: 'Account already exist'} if account.present?

      email_validation = AccountBlock::EmailValidation.new(account_params[:email])
      unless email_validation.valid?
        return render json: { message: email_validation.errors.full_messages.first, status: 400}
      end
      @account = EmailAccount.new(account_params)
      @account.temporary_token = loop do
        random_token = SecureRandom.hex(30)
        break random_token unless AccountBlock::Account.exists?(temporary_token: random_token)
      end

      # link = Rails.env.development? ? 'https://localhost:3000' : ENV["UI_URL"]
      # @url = "{{local}}/account_block/accounts/activate_account?id{@account.id}"
      @account.platform = request.headers['platform'].downcase if request.headers.include?('platform')

      if @account.save
        if @account.user_type == 'inspector'
          send_otp_to_admin(account_params[:email])
        else
          EmailValidationMailer
                .with(account: @account, host: request.base_url)
                .activation_email.deliver_now
          # @link = "#{link}/account_block/accounts/activate_account?token=#{encode(@account.id)}"
          render json: AccountSerializer.new(@account, meta: {
                token: encode(@account.id)
              }).serializable_hash, status: :created
        end
        mixpanel_service = BxBlockMixpanelIntegration::MixpanelService.new
        mixpanel_service.find_or_create_account(@account)
      else
        render json: {errors: format_activerecord_errors(@account.errors)},
              status: :unprocessable_entity
      end
    end

    def search
      @accounts = Account.where(activated: true)
                    .where('first_name ILIKE :search OR '\
                           'last_name ILIKE :search OR '\
                           'email ILIKE :search', search: "%#{search_params[:query]}%")
      if @accounts.present?
        render json: AccountSerializer.new(@accounts, meta: {message: 'List of users.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any user.'}]}, status: :ok
      end
    end

    def activate_account
      token = params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @account = AccountBlock::Account.find_by(id: @token.id).update(activated: true)
      render json: "Your Account Is Activated"
    end

    def send_otp_to_admin_email
      account = AccountBlock::Account.where('LOWER(email) = ?', params[:email]&.downcase)&.first
      return render json: {error: {message: 'Email not exist'}}, status: :not_found unless account
      
      AccountBlock::EmailOtp.where(email: params[:email]).destroy_all
      email_otp = AccountBlock::EmailOtp.new(email: params[:email])
      if email_otp.save
        send_email_for email_otp
        render json: {
          message: "OTP Sent To Admin Email Successfully",
          meta: {token: BuilderJsonWebToken.encode(account.id, 15.minutes.from_now)} 
          } 
      else
        render json: {
          errors: [email_otp.errors],
        }, status: :unprocessable_entity
      end
    end

    def get_term_and_condition
      current_user = AccountBlock::Account.find_by(id: @token.id)
      render json: {status: true, terms_and_conditions: current_user&.terms_and_conditions }, status: :ok
    end

    def update_term_and_condition
      current_user = AccountBlock::Account.find_by(id: @token.id)
      if current_user.present?
        current_user.update(terms_and_conditions: params[:response])
        render json: {message: "Terms and condition updated!" }, status: :ok
      end
    end

    def delete_account
      current_user = AccountBlock::Account.find_by(id: @token.id)
      if current_user.present?
        current_user.destroy!
        render json: {message: "#{current_user.full_name} deleted permanently" }, status: :ok
      end
    end

    def delete_account_with_id
      current_user = AccountBlock::Account.find_by(email: params[:email])
      if current_user.present?
        current_user.destroy!
        render json: {message: "#{current_user.full_name} deleted permanently" }, status: :ok
      else
        render json: {message: "#{params[:email]} email not found" }, status: :ok
      end
    end

    private

    def email_otp_params

      email = {:email => jsonapi_deserialize(params)["email"]}
    end

    def send_email_for(otp_record)
      EmailOtpAdminMailer
        .with(otp: otp_record, host: request.base_url)
        .otp_email_admin.deliver_now unless Rails.env.test? 
    end

    def encode(id)
      BuilderJsonWebToken.encode id
    end

    def search_params
      params.permit(:query)
    end

    def format_activerecord_errors(errors)
        result = []
        errors.each do |attribute, error|
          result << { attribute => error }
        end
        result
    end

    def send_sms_after_signup full_phone_number
      send_otp = AccountBlock::SmsOtp.new(full_phone_number: full_phone_number)
      if send_otp.save(validate: false)
        data = serialized_sms_otp(send_otp, @account.id)
        return data
      else
        return "Something went wrong, unable to sent the send Otp."
      end

    end


    def serialized_sms_otp(sms_otp, account_id)
      token = token_for(sms_otp, account_id)
      SmsOtpSerializer.new(
        sms_otp,
        meta: { token: token }
      ).serializable_hash
    end

    def token_for(otp_record, account_id)
      BuilderJsonWebToken.encode(
        otp_record.id,
        5.minutes.from_now,
        type: otp_record.class,
        account_id: account_id
      )
    end

    def get_docs
      params.require(:data)[:attributes].permit(:full_name,:company_name,:phone_number,:email,:country_code, :country, :inspector_code, :device_id, :fcm_device_token,  :terms_and_conditions,:device_type , :temp_car_ad_id, :docs => [])
    end

    def send_otp_to_admin(email)
      email_otp = AccountBlock::EmailOtp.new(email: email)
      if email_otp.save
        send_email_for email_otp
        render json: {
          message: "OTP Sent To Admin Email Successfully",
          meta: {token: BuilderJsonWebToken.encode(@account.id, 15.minutes.from_now)} 
          } 
      else
        render json: {
          errors: [email_otp.errors],
        }, status: :unprocessable_entity
      end
    end

    def user_params
      account_params = get_docs
      account_params[:full_phone_number] = account_params["country_code"] + account_params["phone_number"] rescue account_params["phone_number"]
      account_params[:password] = SecureRandom.hex
      
      if ActiveModel::Type::Boolean.new.cast(params[:data][:inspector])
        account_params["user_type"] = "inspector"
      elsif account_params["full_name"].present?
        account_params["user_type"] = "individual"       
      else 
        account_params["user_type"] = "business"
      end
      account_params
    end

  end
end
