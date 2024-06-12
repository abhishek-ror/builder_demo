FactoryBot.define do
  factory :shipping_carge, class: 'BxBlockRateCard::ShippingCharge' do
    destination_country{ 'India' }
    price { '8000' }
    in_transit { '800' }
    source_country { 'India' }
    destination_port { 'Kolkata' }
  end
end