module BxBlockRateCards
  class ShippingChargeSerializer < BuilderBase::BaseSerializer
  # include JSONAPI::Serializer
    attributes *[
      :id,
      :destination_country,
      :destination_port,
      :price,
      :in_transit
      ]
  end
end
