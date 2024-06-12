module BxBlockRateCards
  class DocumentationChargeSerializer < BuilderBase::BaseSerializer
    # include JSONAPI::Serializer
      attributes *[
       :id,
       :country,
       :region,
       :price
    ] 
  end
end
