class CreateBxBlockReviewsAppReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :app_reviews do |t|
      t.references :account, foreign_key: true
      t.text :description
      t.integer :rating
      t.timestamps
    end
  end
end
