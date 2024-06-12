module BxBlockRateCards
  class DestinationHandlingSerializer
    include JSONAPI::Serializer
    attributes *[
      :id,
      :destination_country,
      :unloading,
      :customs_clearance,
      :storage
      ]
  end
end
