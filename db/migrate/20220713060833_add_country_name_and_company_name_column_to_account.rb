class AddCountryNameAndCompanyNameColumnToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :company_name, :string
    add_column :accounts, :country_name, :string
  end
end
