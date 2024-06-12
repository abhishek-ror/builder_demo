FactoryBot.define do
    factory :car_ad, class: 'BxBlockAdmin::CarAd' do
      make_year { 1998 }
      mileage{ 45 }
      body_color{ 'red' }
      price{ 2000000 }
      status { 1 }
      ad_type{ 1 }
      kms{ '3000' }
      mobile_number{ '7974578598' }
      car_type{ 'new_car' }
      horse_power{ 5 }
      no_of_doors { 4 }
      more_details { 'this is my new car i want to selling a car which is the best for you budger ' }
      steering_side { 2 }
      no_of_cylinder { 6 }
      battery_capacity { 30000 }
      warranty { 1 }
      body_type { 'plastic' }
    end
  end