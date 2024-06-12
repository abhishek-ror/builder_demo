class AddFieldsToCarAds < ActiveRecord::Migration[6.0]
  def change
    add_reference :car_ads, :user_subscription
  end
end
