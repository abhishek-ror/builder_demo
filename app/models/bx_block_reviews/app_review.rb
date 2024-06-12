module BxBlockReviews
	class AppReview < BxBlockReviews::ApplicationRecord
	  self.table_name = :app_reviews
	  belongs_to :account, class_name: 'AccountBlock::Account'
      validates :rating, presence: { message: "Please provide a rating" }, inclusion: { in: 1..5, message: "must be between 1 and 5" }
	end
end