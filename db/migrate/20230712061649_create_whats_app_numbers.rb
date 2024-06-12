class CreateWhatsAppNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :whats_app_numbers do |t|
      t.string :whatsapp_number
      t.string :country_code

      t.timestamps
    end
  end
end
