class AddDescriptionTitleToFlashScreens < ActiveRecord::Migration[6.0]
  def change
    add_column :flash_screens, :description_title, :string
  end
end
