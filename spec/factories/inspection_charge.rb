FactoryBot.define do
	factory :inspection_charge, class: 'BxBlockRateCard::InspectionCharge' do
		country { 'Japan' }
        region { 'Asia' }
        price { 600 }
	end
end