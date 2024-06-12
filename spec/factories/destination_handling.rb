FactoryBot.define do
  factory :destination_handling, class: 'BxBlockRateCard::DestinationHandling' do
    destination_country{ 'France' }
    unloading { '8000' }
    customs_clearance { '800' }
    storage { '80' }
  end
end