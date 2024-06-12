module BxBlockProfile
  class ProfileSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :country,
      :city,
      :postal_code,
      :profile_role
    ]

    attributes :email do |object|
      get_email object
    end

    attributes :full_phone_number do |object|
      get_full_phone_number object
    end

    attributes :photo do |object|
      # object.photo.attached? ? Rails.application.routes.url_helpers.rails_blob_path(object.photo, only_path: true) : "image not present"
      object.photo.attached? ? object.photo.service_url : nil
    end

    attributes :address do |object|
      user_address object
    end

    attributes :account do |object|
      get_account_details object
    end


    
    class << self
      private

      def user_address object
        address = []
        get_address = BxBlockAddress::Address.find_by(account_id: object.account_id)
        get_account = AccountBlock::Account.find_by(id: object.account_id)
        get_address[:country] = get_account[:country] if get_address.present?
        if get_address
          address << BxBlockAddress::AddressSerializer.new(get_address)
        else
          address << "Address is not present"
        end
      end

      def get_account_details object
        account_details = []
        get_account = AccountBlock::Account.find_by(id: object.account_id)
        if get_account
          account_details << AccountBlock::EmailAccountSerializer.new(get_account)
        end
      end

      def get_email object
        get_account = AccountBlock::Account.find_by(id: object.account_id)
        get_account.email if get_account.present?
      end

      def get_full_phone_number object
        get_account = AccountBlock::Account.find_by(id: object.account_id)
        get_account.full_phone_number if get_account.present?
      end


    end

  end
end
