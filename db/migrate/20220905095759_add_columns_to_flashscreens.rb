class AddColumnsToFlashscreens < ActiveRecord::Migration[6.0]
  def change
    add_column :flash_screens, :offer, :text
    add_column :flash_screens, :tips_for_advertisment_posting, :text
    add_column :flash_screens, :offer_title, :string
    add_column :flash_screens, :tips_title, :string
  end
end
