class CreateServiceShippings < ActiveRecord::Migration[6.0]
  def change
    create_table :service_shippings do |t|
      t.string :title

      t.timestamps
    end
  end
end
