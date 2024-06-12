FactoryBot.define do
	factory :documentation_charge, class: 'BxBlockRateCard::DocumentationCharge' do
		country { 'Japan' }
        region { 'Asia' }
        price { "600" }
	end
end