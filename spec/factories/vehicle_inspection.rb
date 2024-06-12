FactoryBot.define do
  factory :vehicle_inspection, class: 'BxBlockAdmin::VehicleInspection' do
    make_year{ '1998' }
    about{ 'Vehicle inspection of my car' }
    price{ 2000000 }
    vin_number{ '12345' }
    seller_name{ 'Test' }
    seller_country_code {'+91'}
    seller_mobile_number{ '134567890' }
    seller_email{ 'test@gmail.com' }
    inspection_amount{ 899 }
    final_sale_amount{ 1000 }
    instant_deposit_amount{ 100 }
    advertisement_url{"https://carshipapp-117228-ruby.b117228.dev.eastus.az.svc.builder.cafe/admin"}
    notes_for_the_inspector{ 'Vehicle inspection is a procedure for inspector'}
    notes_for_the_admin{'Vehicle is the best for selling' }
    city {association :city}
    account {association :account}
    model {association :model}
  end
end
