class ChangeColumnsInGlobalOffices < ActiveRecord::Migration[6.0]
  def change
    add_column :global_offices, :address_line_1, :text
    add_column :global_offices, :address_line_2, :text
    add_reference :global_offices, :city, null: false, foreign_key: true, default: 1
    remove_column :global_offices, :address
    remove_column :global_offices, :contact_email
    remove_column :global_offices, :contact_no
  end
end
