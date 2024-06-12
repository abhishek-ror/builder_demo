class CreateShipmentUserReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :shipment_user_reviews do |t|
      t.references :account, null: false
      t.references :shipment
      t.text :review
      t.integer :quick_response_rating
      t.integer :detailed_service_rating
      t.integer :supportive_rating
    end
  end
end
