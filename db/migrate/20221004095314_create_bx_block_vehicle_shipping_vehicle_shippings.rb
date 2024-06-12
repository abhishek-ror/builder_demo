class CreateBxBlockVehicleShippingVehicleShippings < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_shippings do |t|

      t.string  :region
      t.string  :country
      t.string  :state
      t.string  :area
      t.integer :year
      t.string  :make
      t.string  :model 
      t.string :regional_specs
      t.string  :country_code
      t.string  :phone_number
      t.string  :full_phone_number
      t.string  :source_country
      t.string  :pickup_port
      t.string  :destination_country
      t.string  :destination_port
      t.text    :shipping_instruction
      t.integer :account_id
      t.integer :final_shipping_amount
      t.integer :payment_confirmation_status
      t.integer :status
      t.datetime   :estimated_time_of_departure
      t.datetime   :estimated_time_of_arrival
      t.string  :shipping_line
      t.string  :container_number
      t.string  :bl_number
      t.string  :tracking_link
      t.integer  :delivery_status
      t.string  :payment_link
      t.text    :review

      t.timestamps
    end
  end
end
