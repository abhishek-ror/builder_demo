FactoryBot.define do
  factory :shipping_charge, class: 'BxBlockRateCard::ShippingCharge' do
    source_country { 'USA' }
    destination_country { 'UK' }
    destination_port { 'SomePort' }
    price { 100 }
    in_transit { 100 }
  end
end