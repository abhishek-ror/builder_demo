module BxBlockAddress
  class AddressSerializer < BuilderBase::BaseSerializer

    attributes *[
      :latitude,
      :longitude,
      :address_type,
      :building_name,
      :street_address,
      :post_box,
      :city,
      :state
    ]
  end
end