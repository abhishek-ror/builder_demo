FactoryBot.define do
  IMAGE = fixture_file_upload(Rails.root.join('app/assets/images/test-image.png'), 'image/jpeg')
  FILE = fixture_file_upload(Rails.root.join('app/assets/images/Privacy_Policy.pdf'), 'image/pdf')
  factory :vehicle_shipping, class: BxBlockVehicleShipping::VehicleShipping do
    region{ FactoryBot.create(:region) }
	  country{ FactoryBot.create(:country) }
	  state{ FactoryBot.create(:state) }
	  area{ "Nagpur" }
	  year{ 2023 }
	  make{ "BMW" }
	  model{ FactoryBot.create(:model) }
	  regional_specs{ "asia" }
	  country_code{ "91" }
	  phone_number{ Faker::PhoneNumber.phone_number }
	  source_country{ "India" }
	  pickup_port{ "Us Main port" }
	  destination_country{ "India" }
	  destination_port{ "chennai" }
	  shipping_instruction{ "Please ship my car without damage" }
    invoice_amount { "100" }
    passport { IMAGE }
    export_certificate { FILE }
    shipping_invoice { IMAGE }
    conditional_report { IMAGE }
    other_documents { FILE }
    condition_pictures { IMAGE }
    delivery_proof { FILE }
    delivery_invoice { FILE }
    loading_image { FILE }
    unloading_image { FILE }
  end
end