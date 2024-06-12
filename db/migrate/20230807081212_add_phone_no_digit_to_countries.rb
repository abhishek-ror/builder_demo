class AddPhoneNoDigitToCountries < ActiveRecord::Migration[6.0]
  def change
    add_column :countries, :phone_no_digit, :integer
  end
end
