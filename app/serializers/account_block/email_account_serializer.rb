module AccountBlock
  class EmailAccountSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :full_name,
      :company_name,
      :full_phone_number,
      :country_code,
      :country,
      :phone_number,
      :email,
      :user_type,
      :activated,
    ]
  end
end
