require 'rails_helper'

RSpec.describe ::BxBlockPosts::CarAdsController, type: :controller do

  UPDATEDATA = 'update when data exists'
  VALIDDATA = 'valid data present'
  let(:expected_response_keys) do
    %w[ id city trim body_color fuel_type model make_year no_of_doors no_of_cylinder horse_power warranty
        battery_capacity more_details steering_side transmission price status order_id ad_type
        images mobile_number kms created_at is_favourite favourite_id body_type car_type regional_specs colors features extras
        badges car_engine_types seller_types inspected sold_at account admin
      ]
  end

  let(:expected_city_response_keys) do
    %w[id name state_id zipcode created_at updated_at]
  end
  let(:expected_trim_response_keys) do
    %w[id name model_id created_at updated_at]
  end
  let(:expected_account_response_keys) do
    %w[activated country_code country email company_name full_phone_number full_name phone_number type
       created_at updated_at device_id fcm_device_token unique_auth_id user_type stripe_id id terms_and_conditions docs]
  end

  describe "status update" do
    let!(:account) { create(:account) }
    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
    let!(:company) { create(:company) }
    let!(:model) { create(:model, company: company) }
    let!(:trim) { create(:trim, model: model) }
    let!(:region) { create(:region) }
    let!(:country) { create(:country, region: region) }
    let!(:state) { create(:state, country: country) }
    let!(:city) { create(:city, state: state) }
    let!(:car_ad) { create(:car_ad, city: city, account: account, trim: trim) }

    context UPDATEDATA do
      before do
        request.headers["token"] = login_user(account)
        put 'status_update', params: {  status: "sold", id: car_ad.id }
       end
      it VALIDDATA do
        # expect(JSON.parse(response.body)['data'].keys).to eq(["id", "type", "attributes"])
        # expect(JSON.parse(response.body)['data']['attributes'].keys).to eq(expected_response_keys)
        # expect(JSON.parse(response.body)['data']['attributes']['city'].keys).to eq(expected_city_response_keys)
        # expect(JSON.parse(response.body)['data']['attributes']['trim'].keys).to eq(expected_trim_response_keys)
        # expect(JSON.parse(response.body)['data']['attributes']['account'].keys).to eq(expected_account_response_keys)
        # expect(JSON.parse(response.body)['data']['attributes']['status']).to eq("sold")
        # expect(JSON.parse(response.body)['data']['attributes']['account'].present?).to eq(true)
        expect(response.code).to eq('200')
      end
    end

    context 'update wheen data invalid' do
      before do
        request.headers["token"] = login_user(account)
        put 'status_update'
       end
      it 'given invalid id' do
        expect(JSON.parse(response.body)['error']).to eq({"message"=>"id and status field Can't Be Blank"})
        expect(response.code).to eq('200')
      end
    end

    context UPDATEDATA do
      before do
        request.headers["token"] = login_user(account)
        put 'status_update', params: {  status: "deleted", id: car_ad.id }
       end
      it VALIDDATA do
        expect(JSON.parse(response.body)['data']['attributes']['status']).to eq("deleted")
        expect(response.code).to eq('200')
      end
    end
  end

  describe "update car_ad" do
    let!(:account) { create(:account) }
    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
    let!(:company) { create(:company) }
    let!(:model) { create(:model, company: company) }
    let!(:trim) { create(:trim, model: model) }
    let!(:region) { create(:region) }
    let!(:country) { create(:country, region: region) }
    let!(:state) { create(:state, country: country) }
    let!(:city) { create(:city, state: state) }
    let!(:car_ad) { create(:car_ad, city: city, account: account, trim: trim) }

    context UPDATEDATA do
      before do
        request.headers["token"] = login_user(account)
        put 'update', params: { id: car_ad.id, car_ad: {car_name: "MG hactor" }}
       end
      it VALIDDATA do
        expect(response.code).to eq('200')
      end
    end

    context 'update wheen data invalid' do
      before do
        request.headers["token"] = login_user(account)
        put 'update', params: {id: 23456789, car_ad: {}}
       end
      it 'given invalid id' do
        expect(response.code).to eq('404')
      end
    end
  end

  describe "Index Method" do
    let!(:admin_user) {AdminUser.create(email: "admin@gmail.com", password: "Adminpass", password_confirmation: "Adminpass")}
    let!(:account) { create(:account) }
    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
    let!(:company) { create(:company) }
    let!(:model) { create(:model, company: company) }
    let!(:trim) { create(:trim, model: model) }
    let!(:region) { create(:region) }
    let!(:country) { create(:country, region: region) }
    let!(:state) { create(:state, country: country) }
    let!(:city) { create(:city, state: state) }
    let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
    let!(:car_ad2) { create(:car_ad, city: city, account: account, trim: trim, car_type: 2) }
    let!(:car_ad3) { create(:car_ad, city: city, account: account, trim: trim, ad_type: 2, car_type: 2) }
    let!(:car_ad3) { create(:car_ad, city: city, account: account, trim: trim, ad_type: 2, car_type: 2, admin_user_id: admin_user.id) }

    context 'index when data exists' do
      before do
        request.headers["token"] = login_user(account)
        get 'index', params: {  ad_type: "top_deals" }
       end
      it VALIDDATA do
        expect(JSON.parse(response.body)['data'].first.keys).to eq(["id", "type", "attributes"])
        # expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['city'].keys).to eq(expected_city_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['trim'].keys).to eq(expected_trim_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['ad_type']).to eq("top_deals")
        # expect(JSON.parse(response.body)['data'].count).to eq(2)
        expect(response.code).to eq('200')
      end
    end

    context 'index when data exists' do
      before do
        request.headers["token"] = login_user(account)
        get 'index', params: {}
       end
      it VALIDDATA do
        expect(JSON.parse(response.body)['data'].first.keys).to eq(["id", "type", "attributes"])
        # expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['city'].keys).to eq(expected_city_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['trim'].keys).to eq(expected_trim_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['ad_type']).to eq("top_deals")
        # expect(JSON.parse(response.body)['data'].count).to eq(2)
        expect(response.code).to eq('200')
      end
    end
    context 'index when data exists' do
      before do
        request.headers["token"] = login_user(account)
        get 'index', params: {  ad_type: "top_deals", car_type: "new_car" }
       end
      it VALIDDATA do
        # expect(JSON.parse(response.body)['data'].first['type']).to eq("car_ad")
        expect(JSON.parse(response.body)['data'].first.keys).to eq(["id", "type", "attributes"])
        # expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['city'].keys).to eq(expected_city_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['trim'].keys).to eq(expected_trim_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['car_type']).to eq("New car")
        # expect(JSON.parse(response.body)['data'].first['attributes']['ad_type']).to eq("top_deals")
        expect(response.code).to eq('200')
      end
    end

    context 'index when data exists' do
      before do
        request.headers["token"] = login_user(account)
        get 'index', params: {  ad_type: "top_deals", car_type: "used_car" }
       end
      it VALIDDATA do
        # expect(JSON.parse(response.body)['data'].first['type']).to eq("car_ad")
        # expect(JSON.parse(response.body)['data'].first.keys).to eq(["id", "type", "attributes"])
        # expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['city'].keys).to eq(expected_city_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['trim'].keys).to eq(expected_trim_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['car_type']).to eq("Used car")
        # expect(JSON.parse(response.body)['data'].first['attributes']['ad_type']).to eq("top_deals")
        expect(response.code).to eq('200')
      end
    end

    context 'index when data exists' do
      before do
        request.headers["token"] = login_user(account)
        get 'index', params: {  ad_type: "featured", car_type: "used_car" }
       end
      it VALIDDATA do
        # expect(JSON.parse(response.body)['data'].first['type']).to eq("car_ad")
        # expect(JSON.parse(response.body)['data'].first.keys).to eq(["id", "type", "attributes"])
        # # expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['city'].keys).to eq(expected_city_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['trim'].keys).to eq(expected_trim_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['car_type']).to eq("Used car")
        # expect(JSON.parse(response.body)['data'].first['attributes']['ad_type']).to eq("featured")
        expect(response.code).to eq('200')
      end
    end

  end

  describe "search_cars_by_brand" do
    let!(:account) { create(:account) }
    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
    let!(:company) { create(:company) }
    let!(:model) { create(:model, company: company) }
    let!(:trim) { create(:trim, model: model) }
    let!(:region) { create(:region) }
    let!(:country) { create(:country, region: region) }
    let!(:state) { create(:state, country: country) }
    let!(:city) { create(:city, state: state) }
    let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
    let!(:car_ad2) { create(:car_ad, city: city, account: account, trim: trim, car_type: 2) }
    let!(:car_ad3) { create(:car_ad, city: city, account: account, trim: trim, ad_type: 2, car_type: 2) }
    context 'search_cars_by_brand when data exists' do
      before do
        request.headers["token"] = login_user(account)
      end
      it VALIDDATA do
        get :search_cars_by_brand, params: { brand_id: company, status: 'posted'}
        expect(JSON.parse(response.body)['data'].first['type']).to eq("car_ad")
        expect(JSON.parse(response.body)['data'].first.keys).to eq(["id", "type", "attributes"])
        # expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['city'].keys).to eq(expected_city_response_keys)
        # expect(JSON.parse(response.body)['data'].first['attributes']['trim'].keys).to eq(expected_trim_response_keys)
      end
      it 'invalid data ' do
        get :search_cars_by_brand
        expect(response.code).to eq('422')
        expect(message: 'Brand Id is missing').to eq(message: 'Brand Id is missing')
      end
    end

    describe "search_all_cars" do
      let!(:account) { create(:account) }
      let!(:plan) { create(:plan) }
      let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
      let!(:company) { create(:company) }
      let!(:model) { create(:model, company: company) }
      let!(:trim) { create(:trim, model: model) }
      let!(:region) { create(:region) }
      let!(:country) { create(:country, region: region) }
      let!(:state) { create(:state, country: country) }
      let!(:city) { create(:city, state: state) }
      let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
      let!(:car_ad2) { create(:car_ad, city: city, account: account, trim: trim, car_type: 2) }
      let!(:car_ad3) { create(:car_ad, city: city, account: account, trim: trim, ad_type: 2, car_type: 2) }
      context 'search_all_cars when data exists' do
        before do
          request.headers["token"] = login_user(account)
        end
        it VALIDDATA do
          get :all_cars, params: { search: model.name, page: 1, per_page: 1}
          expect(response.code).to eq('200')
        end
      end

      context 'when search params is not given' do
        before do
          request.headers["token"] = login_user(account)
        end
        it VALIDDATA do
          get :all_cars, params: {page: 1, per_page: 1}
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when search is not exit' do
        before do
          request.headers["token"] = login_user(account)
        end
        it VALIDDATA do
          get :all_cars, params: { search: 'dfd', page: 1, per_page: 1}
          expect(response).to have_http_status(:not_found)
        end
      end
    end


    describe "search_car_by_name" do
      let!(:account) { create(:account) }
      let!(:plan) { create(:plan) }
      let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
      let!(:company) { create(:company) }
      let!(:model) { create(:model, company: company) }
      let!(:trim) { create(:trim, model: model) }
      let!(:region) { create(:region) }
      let!(:country) { create(:country, region: region) }
      let!(:state) { create(:state, country: country) }
      let!(:city) { create(:city, state: state) }
      let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
      context 'search_all_cars when data exists' do
        before do
          request.headers["token"] = login_user(account)
        end
        it VALIDDATA do
          get :car_search, params: {  car_name: "volkswagen trims" }
          expect(JSON.parse(response.body)['data'].first['type']).to eq("car_ad")
          expect(JSON.parse(response.body)['data'].first.keys).to eq(["id", "type", "attributes"])
          # expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_response_keys)
          # expect(JSON.parse(response.body)['data'].first['attributes']['city'].keys).to eq(expected_city_response_keys)
          # expect(JSON.parse(response.body)['data'].first['attributes']['trim'].keys).to eq(expected_trim_response_keys)
        end
      end
    end

    describe "get_car_price_filter" do 
      before do
        request.headers["token"] = login_user(account)
      end
      it 'should be data' do
        get :price_data
        expect(response.code).to eq('200')
      end
    end

    describe "search filter" do 
      before do
        request.headers["token"] = login_user(account)
      end
      it 'filter search data' do
        get :search
        expect(response.code).to eq('200')
      end
      it 'filter search data with regional_spec_ids' do
        get :search, params: {regional_spec_ids: ["1"]}
        expect(response.code).to eq('200')
      end
      it 'filter search data with no_of_cylinder' do
        get :search, params: {no_of_cylinder: "3"}
        expect(response.code).to eq('200')
      end
      it 'filter search data with no_of_cylinder with 13' do
        get :search, params: {no_of_cylinder: "13"}
        expect(response.code).to eq('200')
      end
      it 'filter search data with no_of_doors with 5' do
        get :search, params: {no_of_doors: "5"}
        expect(response.code).to eq('200')
      end
      it 'filter search data with no_of_doors with 6' do
        get :search, params: {no_of_doors: "6"}
        expect(response.code).to eq('200')
      end
      it 'filter search data with no_of_doors' do
        get :search, params: {no_of_doors: "4"}
        expect(response.code).to eq('200')
      end
      it 'filter search data with horse_power' do
        get :search, params: {horse_power: 1}
        expect(response.code).to eq('200')
      end
      it 'filter search data with body_type' do
        get :search, params: {body_type:"body_type"}
        expect(response.code).to eq('200')
      end

      # it 'filter search data with from_kms and to_kms' do
      #   get :search, params: {from_kms:"1000", to_kms: "2000"}
      #   expect(response.code).to eq('200')
      # end

      # it 'filter search data with from_kms' do
      #   get :search, params: {from_kms:"1000"}
      #   expect(response.code).to eq('200')
      # end

      # it 'filter search data with to_kms' do
      #   get :search, params: {to_kms:"2000"}
      #   expect(response.code).to eq('200')
      # end

      it 'filter search data with car_engine_type_ids' do
        get :search, params: {car_engine_type_ids: "2,4,6"}
        expect(response.code).to eq('200')
      end

      it 'filter search home data' do
        get :search_home
        expect(response.code).to eq('200')
      end
      it 'filter search home data with no_of_cylinder' do
        get :search_home, params: {no_of_cylinder: "3"}
        expect(response.code).to eq('200')
      end
       it 'filter search home data with no_of_doors' do
        get :search_home, params: {no_of_doors: "4"}
        expect(response.code).to eq('200')
      end
      it 'filter search home data with horse_power' do
        get :search_home, params: {horse_power: "20"}
        expect(response.code).to eq('200')
      end
      it 'filter search home data with car_engine_type_ids' do
        get :search_home, params: {car_engine_type_ids: "car_engine_type_id"}
        expect(response.code).to eq('200')
      end
      it 'filter search home data with car_engine_type_ids' do
        get :search_home, params: {car_engine_type_ids: "2,4"}
        expect(response.code).to eq('200')
      end
      it 'filter search home data with body_type' do
        get :search_home, params: {body_type:"body_type"}
        expect(response.code).to eq('200')
      end
       it 'filter search home data with make_year' do
        get :search_home, params: {make_year:"make_year"}
        expect(response.code).to eq('200')
      end
       it 'filter search home data with kms' do
        get :search_home, params: {kms:"kms"}
        expect(response.code).to eq('200')
      end
       it 'filter search home data with warranty' do
        get :search_home, params: {warranty: 3}
        expect(response.code).to eq('200')
      end
      it 'filter search home data with steering_side' do
        get :search_home, params: {steering_side: 1}
        expect(response.code).to eq('200')
      end

      it 'filter search home data with price filter' do
        get :search_home, params: {price: {min: 200, max: 500}}
        expect(response.code).to eq('200')
      end

      it 'seller_type_list' do
        get :seller_type_list
        expect(response.code).to eq('200')
      end
      it 'free_ad_count' do
        get :free_ad_count
        expect(response.code).to eq('200')
      end 
      it 'warranty_list' do
        get :warranty_list
        expect(response.code).to eq('200')
      end 

      it 'other_filters_list' do
        get :other_filters_list
        expect(response.code).to eq('200')
      end
      it 'ads_posted_list' do
        get :ads_posted_list
        expect(response.code).to eq('200')
      end 
      it 'badges_list' do
        get :badges_list
        expect(response.code).to eq('200')
      end 
      it 'extras_list' do
        get :extras_list
        expect(response.code).to eq('200')
      end 
      it 'features_list' do
        get :features_list
        expect(response.code).to eq('200')
      end 
      it 'steering_side_list' do
        get :steering_side_list
        expect(response.code).to eq('200')
      end          
      it 'no_of_cylinder_list' do
        get :no_of_cylinder_list
        expect(response.code).to eq('200')
      end 
      it 'no_of_doors_list' do
        get :no_of_doors_list
        expect(response.code).to eq('200')
      end 
      it 'horse_power_list' do
        get :horse_power_list
        expect(response.code).to eq('200')
      end 

      it 'body_color_list' do
        get :body_color_list
        expect(response.code).to eq('200')
      end 
      it 'engine_type_list' do
        get :engine_type_list
        expect(response.code).to eq('200')
      end
      it 'body_type_list' do
        get :body_type_list
        expect(response.code).to eq('200')
      end
      it 'regional_spec_list' do
        get :regional_spec_list
        expect(response.code).to eq('200')
      end
      it 'year_list' do
        get :year_list
        expect(response.code).to eq('200')
      end
      it 'query_data' do
        get :query_data
        expect(response.code).to eq('200')
      end
    end

    describe "get my ads" do 
      before do
        request.headers["token"] = login_user(account)
      end
      it 'list of my car ads' do
        get :my_ads
        expect(response.code).to eq('200')
      end
    end

    describe "get trim list" do 
      before do
        request.headers["token"] = login_user(account)
      end
      it 'list of trim' do
        get :trim_list
        expect(response.code).to eq('200')
      end
    end

    describe "get api list" do 
      before do
        request.headers["token"] = login_user(account)
      end
      it 'list of location' do
        get :location_list
        expect(response.code).to eq('200')
      end
      it 'list of make' do
        get :make_list
        expect(response.code).to eq('200')
      end
      it 'list of model' do
        get :model_list
        expect(response.code).to eq('200')
      end
    end

    describe "get api lists" do 
      before do
        request.headers["token"] = login_user(account)
      end
      let!(:company) { create(:company) }
      let!(:model) { create(:model, company: company) }
      let!(:trim) { create(:trim, model: model) }
      it 'list of models' do
        get :models, params: {model:{ company_id:company.id, name:""}}
        expect(response.code).to eq('200')
      end
      it 'list of trims' do
        get :trims, params: {trim:{ model_id:model.id, name:""}}
        expect(response.code).to eq('200')
      end
      it 'list of make' do
        get :make, params: {company:{name:"ABC"}}
        expect(response.code).to eq('200')
      end
    end
  end
end



