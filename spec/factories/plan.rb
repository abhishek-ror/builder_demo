FactoryBot.define do
    factory :plan, class: 'BxBlockPlan::Plan' do
      name{ 'Paid Plan' }
      duration{ 1 }
      price{ 500.0 }
      ad_count{ 10 }
      details { 'this is my new car i want to selling a car which is the best for you budge' }
    end
  end
