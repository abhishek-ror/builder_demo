module BxBlockRateCards
  class InspectionChargeSerializer < BuilderBase::BaseSerializer
  # include JSONAPI::Serializer
    attributes *[
       :id,
       :country,
       :region,
       :price
      ]
  end
end
