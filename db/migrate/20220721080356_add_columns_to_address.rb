class AddColumnsToAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :flat_no, :string
    add_column :addresses, :building_name, :string
    add_column :addresses, :street_address, :string
    add_column :addresses, :post_box, :string
    add_column :addresses, :city, :string
    add_column :addresses, :state, :string
  end
end
