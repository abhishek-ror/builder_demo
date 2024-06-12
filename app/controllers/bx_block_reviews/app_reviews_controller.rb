module BxBlockReviews
  class AppReviewsController < ApplicationController
  	include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token
    before_action :current_user

    def create
      review = AppReview.new(review_params)
      review.account_id = current_user.id
      save_result = review.save

      if save_result
        render json: AppReviewSerializer.new(review).serializable_hash,
               status: :created
      else
        render json: ErrorSerializer.new(review).serializable_hash,
               status: :unprocessable_entity
      end
    end

  	private

    def review_params
      params.require(:data).permit(:rating, :description)
    end
  end
end 