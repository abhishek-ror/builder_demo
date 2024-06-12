class AddPhoneNoDigitToRegions < ActiveRecord::Migration[6.0]
  def change
    add_column :regions, :phone_no_digit, :integer
  end
end
