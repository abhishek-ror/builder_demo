class CreateBxBlockShipmentShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :shipments do |t|
      t.date :estimated_time_of_departure
      t.date :estimated_time_of_arrival
      t.string :shipping_line
      t.string :container_number
      t.string :bl_number
      t.string :tracking_link
      t.string :status
      t.integer :car_orders_id
      t.string :delivery_status
      t.string :payment_link
      t.text :review

      t.timestamps
    end
  end
end
