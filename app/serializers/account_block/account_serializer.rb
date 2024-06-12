module AccountBlock
  class AccountSerializer < BuilderBase::BaseSerializer
    attributes *[
      :activated,
      :country_code,
      :country,
      :email,
      :company_name,
      :full_phone_number,
      :full_name,
      :phone_number,
      :type,
      :created_at,
      :updated_at,
      :device_id,
      :fcm_device_token,
      :unique_auth_id,
      :user_type,
      :stripe_id,
      :id,
      :terms_and_conditions,
      :temporary_token
    ]

    attribute :country_code do |object|
      country_code_for object
    end

    attribute :phone_number do |object|
      phone_number_for object
    end

    attributes :docs do |object|
      # object.attachments.attached? ? object.attachments.service_url : nil
      get_attachments object
    end
    
    class << self
      private

      def country_code_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).country_code
      end

      def phone_number_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).raw_national
      end


      def get_attachments object
        attachments = []
        if object.present?
          if object.docs.present?
            object.docs.each do |attach|
              attachments << attach.service_url
            end
          end
        end
        attachments
      end

    end
  end
end
