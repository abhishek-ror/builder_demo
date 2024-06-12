module BxBlockReviews
  class AppReviewSerializer < BuilderBase::BaseSerializer
    include JSONAPI::Serializer
    attributes *[
      :id,
      :rating,
      :description,
      :account_id,
      :created_at
    ]
  end
end
