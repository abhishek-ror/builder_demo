module BxBlockProfile
  class ProfilesController < ApplicationController
    before_action :current_user

    include ActiveStorage::SetCurrent
    def create
      # @profile = current_user.create_profile(profile_params)
      @profile = BxBlockProfile::Profile.create(profile_params.merge({account_id: current_user.id}))

      if @profile.save
        render json: BxBlockProfile::ProfileSerializer.new(@profile
        ).serializable_hash, status: :created
      else
        render json: {
          errors: format_activerecord_errors(@profile.errors)
        }, status: :unprocessable_entity
      end
    end

    def show
      profile = BxBlockProfile::Profile.find_by(account_id: current_user.id)
      if profile.present?
        render json: ProfileSerializer.new(profile).serializable_hash,status: :ok
      else
        render json: {
          errors: format_activerecord_errors(profile.errors)
        }, status: :unprocessable_entity
      end
    end

    # def update
    #   status, result = UpdateAccountCommand.execute(@token.id, update_params)

    #   if status == :ok
    #     serializer = AccountBlock::AccountSerializer.new(result)
    #     render :json => serializer.serializable_hash,
    #       :status => :ok
    #   else
    #     render :json => {:errors => [{:profile => result.first}]},
    #       :status => status
    #   end
    # end


    # def destroy
    #   profile = BxBlockProfile::Profile.find(params[:id])
    #   if profile.present?
    #     profile.destroy
    #     render json:{ meta: { message: "Profile Removed"}}
    #   else
    #     render json:{meta: {message: "Record not found."}}
    #   end
    # end

    def update_profile
      profile = BxBlockProfile::Profile.find_by(account_id: current_user.id)
      if profile.present?
        get_account_params = account_params
        get_account_params[:full_phone_number] = get_account_params["country_code"] + get_account_params["phone_number"] if get_account_params["country_code"].present? && get_account_params["phone_number"].present?
        phone_validator = valid_phone_number(get_account_params[:full_phone_number])
      
        if phone_validator.present?
          render json: {error: "Please enter valid Phone Number"}
        else
          get_account_by_phone =  AccountBlock::EmailAccount.find_by(full_phone_number: get_account_params[:full_phone_number])
          if  get_account_by_phone.present? && get_account_by_phone != current_user
            render json: {error: "Phone Number is used"}
          else 
            current_user.update(get_account_params)
            if params[:data][:photo].blank?
              profile.photo = nil
              profile.save
            end 

            if profile.update(profile_params)
              render json: ProfileSerializer.new(profile, meta: {
                  message: "Profile Updated Successfully"
                }).serializable_hash, status: :ok
            else
              render json: {
                errors: format_activerecord_errors(profile.errors)
              }, status: :unprocessable_entity
            end            
          end
        end
      else
        render json: {msg: "Profile not found"}
      end
    end

    def user_profiles 
      profiles = current_user.profiles
      render json: ProfileSerializer.new(profiles, meta: {
        message: "Successfully Loaded"
      }).serializable_hash, status: :ok
    end
    # remove photo from profile....
    # def delete_image_attachment
    #   if @account.profile.attached?
    #     @account.profile.purge_later
    #     score = @account.profile_score
    #     @account.update(profile_score: score - 5)
    #     render json: {message: "Profile image delete successfully"}
    #   else
    #     render json: {message: "Profile image not present"}
    #   end
    # end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def profile_params
      params.require(:data).permit(:id, :country, :address, :city, :postal_code, :photo, :profile_role)
    end
    def account_params
      params.require(:data).permit(:full_name, :company_name, :email, :phone_number, :country, :country_code, :full_phone_number,:stripe_id,:device_type )
    end

    def valid_phone_number full_phone_number
      unless Phonelib.valid?(full_phone_number)
        "Invalid or Unrecognized Phone Number"
      end
    end


    # def update_params
    #   params.require(:data).permit \
    #     :first_name,
    #     :last_name,
    #     :current_password,
    #     :new_password,
    #     :new_email,
    #     :new_phone_number
    # end
  end
end
