FactoryBot.define do
  factory :address, class: BxBlockAddress::Address do
    building_name { "Test Building" }
    street_address { "Test Street" }
    city { "Test City" }
    state { "Test State" }
    country { "Test Country" }
    latitude { 123.456 }
    longitude { 789.012 }
    address_type { "Home" }

    # Define association if needed
    account
  end
end
