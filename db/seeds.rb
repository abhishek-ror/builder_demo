AdminUser.create(email: 'admin@example.com', password: 'adminpass', password_confirmation: 'adminpass') unless AdminUser.find_by(email: "admin@example.com").present?
# # # BxBlockAdmin::Region.find_or_create_by(name: "Europe")
# # # BxBlockAdmin::Country.find_or_create_by(name: "Francce")
# # # BxBlockAdmin::State.find_or_create_by(name: "state")
# # # BxBlockAdmin::City.find_or_create_by(name: "City")
# # # BxBlockAdmin::Company.find_or_create_by(name: "Volkswagen")
# # # BxBlockAdmin::Model.find_or_create_by(name: "Polo", body_type: "Coupe", engine_type: "BOOm", no_of_doors: 2, no_of_cylinder: 3, horse_power: 240, warranty: "Yes", battery_capacity: "NA", autopilot: true, autopilot_type: "SomeType")
# # # BxBlockAdmin::CarAd.find_or_create_by(city_id: 1, make_year: 2018, mileage: 28, more_details: "SomeText", regional_spec: "Euorpean", steering_side: 1, body_color: "Gold", transmission: 1, price: 3423423423, account_id: 1, admin_user_id: nil, trim_id: 1)

# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
# AdminUser.create(email: 'admin@example.com', password: 'adminpass', password_confirmation: 'adminpass') unless AdminUser.find_by(email: "admin@example.com").present?
# region = BxBlockAdmin::Region.find_or_create_by(name: "Euorpean")
# country = BxBlockAdmin::Country.find_or_create_by(name: "Francce", region_id: region.id)
# state = BxBlockAdmin::State.find_or_create_by(name: "Grand Est", country_id: country.id)
# city = BxBlockAdmin::City.find_or_create_by(name: "Strasbourg" ,zipcode: 435321, state_id: state.id )
# account = AccountBlock::EmailAccount.create(first_name: "ayush", last_name: "test", full_phone_number: "919146206185", country_code: 91, phone_number: 9146206195, email: "ayush1@test.in", activated: true, device_id: nil, type: "EmailAccount", user_name: nil, platform: nil, user_type: "individual", app_language_id: nil, last_visit_at: nil, is_blacklisted: false, suspend_until: nil, status: "regular", stripe_id: nil, stripe_subscription_id: nil, stripe_subscription_date: nil, role_id: nil, full_name: "test1", gender: nil, date_of_birth: nil, age: nil, is_paid: false, company_name: nil, country: "India", password: "ayush1@123")
# company1 = BxBlockAdmin::Company.find_or_create_by(name: "Volkswagen")
# model1 = BxBlockAdmin::Model.find_or_create_by(name: "Polo", body_type: "Coupe", engine_type: "Automatic Transmission", no_of_doors: 2, no_of_cylinder: 3, horse_power: 2040, warranty: true, battery_capacity: 35, autopilot: true, autopilot_type: "Basic autopilot", company_id: company1.id)
# trim1 = BxBlockAdmin::Trim.find_or_create_by(name: "Volkswagen trims", model_id: model1.id)
# company2 = BxBlockAdmin::Company.find_or_create_by(name: "Bmw")
# model2 = BxBlockAdmin::Model.find_or_create_by(name: "BMW X1", body_type: "Crossover", engine_type: "Manual Transmission", no_of_doors: 4, no_of_cylinder: 4, horse_power: 3100, warranty: false, battery_capacity: 45, autopilot: false, autopilot_type: "", company_id: company2.id)
# trim2 = BxBlockAdmin::Trim.find_or_create_by(name: "Bmw trims", model_id: model2.id)
# carad1 = BxBlockAdmin::CarAd.find_or_create_by(city_id: city.id, make_year: 2022, mileage: 35, more_details: "SomeText", regional_spec: "Euorpean", steering_side: 0, body_color: "Green", transmission: 1, price: 3423423423, status: nil, account_id: account.id, admin_user_id: nil, trim_id: trim1.id)
# carad2 = BxBlockAdmin::CarAd.find_or_create_by(city_id: city.id, make_year: 2021, mileage: 21, more_details: "SomeText", regional_spec: "Euorpean", steering_side: 1, body_color: "Gold", transmission: 1, price: 4423423423, status: nil, account_id: account.id, admin_user_id: nil, trim_id: trim1.id)
# carad3 = BxBlockAdmin::CarAd.find_or_create_by(city_id: city.id, make_year: 2017, mileage: 28, more_details: "SomeText", regional_spec: "Euorpean", steering_side: 1, body_color: "yellow", transmission: 1, price: 2423423423, account_id: account.id, admin_user_id: nil, trim_id: trim2.id)
# carad4 = BxBlockAdmin::CarAd.find_or_create_by(city_id: city.id, make_year: 2021, mileage: 30, more_details: "SomeText", regional_spec: "Euorpean", steering_side: 0, body_color: "Green", transmission: 1, price: 3423423423, status: nil, account_id: account.id, admin_user_id: nil, trim_id: trim2.id)
# carad5 = BxBlockAdmin::CarAd.find_or_create_by(city_id: city.id, make_year: 2022, mileage: 25, more_details: "SomeText", regional_spec: "Euorpean", steering_side: 1, body_color: "white", transmission: 1, price: 4423423423, status: nil, account_id: account.id, admin_user_id: nil, trim_id: trim2.id)
# carad6 = BxBlockAdmin::CarAd.find_or_create_by(city_id: city.id, make_year: 2018, mileage: 28, more_details: "SomeText", regional_spec: "Euorpean", steering_side: 1, body_color: "Red", transmission: 1, price: 2423423423, account_id: account.id, admin_user_id: nil, trim_id: trim1.id)
# free_plan = BxBlockPlan::Plan.find_or_create_by(name: "Free Plan")
# AccountBlock::Account.all.each do |account|
	# account.user_subscriptions.find_or_create_by(plan_id: free_plan.id, status: 1)
# end

#Destination servives for vehicle shipping flow
# ServiceShipping.find_or_create_by(title: 'Accept shipping & close the order')
# ServiceShipping.find_or_create_by(title: 'Unloading & close the order')
ServiceShipping.find_or_create_by(title: 'Unloading, customs clearance & close the order')
# ServiceShipping.find_or_create_by(title: 'Unloading,customs clearance, delivery & close the order')
# ServiceShipping.find_or_create_by(title: 'Unloading,customs clearance, miscellaneous services, delivery & close the order')


#Email Notification
# BxBlockAdminEmailNotification::AdminEmailNotification.find_or_create_by(notification_name: "Individual & Business - Account Verification (New user)", content: "Dear User To create a password, please click here. Regards,")
# BxBlockAdminEmailNotification::AdminEmailNotification.find_or_create_by(notification_name: "Inspector Registration - Account verification", content: "Dear User, Please enter this OTP code:- #### to confirm your account. Regards,")
# BxBlockAdminEmailNotification::AdminEmailNotification.find_or_create_by(notification_name: "Verify Your Account/ Forgot Password/ Change Password", content: "Dear User, We have received your request to reset password. Please click here to reset. Regards,")
# BxBlockAdminEmailNotification::AdminEmailNotification.find_or_create_by(notification_name: "Selling flow ads OTP", content: "Your OTP code:- ####")

# #Whatsapp Number
# if BxBlockWhatsappNumber::WhatsAppNumber.count.zero?
#   BxBlockWhatsappNumber::WhatsAppNumber.create(whatsapp_number: '1234567890', country_code: '91')
# end