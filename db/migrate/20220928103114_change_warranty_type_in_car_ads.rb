class ChangeWarrantyTypeInCarAds < ActiveRecord::Migration[6.0]
  def change
    remove_column(:car_ads, :warranty, :boolean)
    add_column :car_ads, :warranty, :integer, default: 0
    add_column :car_ads, :body_type, :string
  end
end
