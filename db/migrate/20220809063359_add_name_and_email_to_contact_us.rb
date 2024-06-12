class AddNameAndEmailToContactUs < ActiveRecord::Migration[6.0]
  def change
    add_column :contact_us, :email, :string
    add_column :contact_us, :name, :string
    remove_column :contact_us, :phone_no
  end
end
