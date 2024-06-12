require 'rails_helper'

RSpec.describe BxBlockFavourites::FavouritesController, type: :controller do

	before do
      @account = create(:account)
      @country = create(:country)
      @city = create(:city)
      @model = create(:model)
      @trim = create(:trim ,model_id: @model.id)
      @state = create(:state)
      @region = create(:region)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)               
      @email_otp = AccountBlock::EmailOtp.create!(email: @account.email)
      @selling = BxBlockVehicleShipping::VehicleSelling.create!(account_id: @account.id, city_id: @city.id, trim_id: @trim.id, region_id: @region.id, country_id: @country.id,state_id: @state.id, price: "100", make: "Tesla", kms: "5", no_of_cylinder: 1, no_of_doors: 4, horse_power: 10, year: 2012)
      @selling_token = BuilderJsonWebToken.encode(@email_otp.id, 5.minutes.from_now, type: @email_otp.class, selling_id: @selling.id)
      request.headers["token"] = login_user(@account)
    end

    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: @account) }
    let!(:car_ad) { create(:car_ad, city: @city, account: @account, trim: @trim) }
  	let(:favouriteable_type) { 'BxBlockVehicleShipping::VehicleSelling' }
  	let(:car_ad_favouriteable_type) { 'BxBlockAdmin::CarAd' }
  	let(:favouriteable_id) { @selling.id }


	describe '#index' do
	    it 'returns a list of favourites for the current user' do
	      selling_favourite = BxBlockFavourites::Favourite.create!(favourite_by_id: @account.id, favouriteable_id: favouriteable_id,favouriteable_type: favouriteable_type)
	      get :index, params: { favouriteable_type: favouriteable_type }, session: { account_id: @account.id }
	      expect(response.status).to eq 200 

	      car_ads_favourite = BxBlockFavourites::Favourite.create!(favourite_by_id: @account.id, favouriteable_id: car_ad.id,favouriteable_type: car_ad_favouriteable_type)
	      get :index, params: { favouriteable_type: car_ad_favouriteable_type}, session: { account_id: @account.id }
	      expect(response.status).to eq 200
	    end

	    it 'returns an empty list if there are no favourites for the current user' do
	      get :index, session: { account_id: @account.id }
			expect(response.status).to eq(404)
	    end
	end

	describe '#create' do
	    it 'creates a favourite for the current user' do
	      post :create, params: { data: {favourite_by_id: @account.id, favouriteable_id: favouriteable_id, favouriteable_type: favouriteable_type } }, session: { account_id: @account.id }
	      expect(response.status).to eq 200
	    end

	    it 'returns an error message if the favourite cannot be created' do
	      allow_any_instance_of(BxBlockFavourites::Favourite).to receive(:save).and_return(false)
	      post :create, params: { data: {favourite_by_id: @account.id, favouriteable_id: favouriteable_id, favouriteable_type: favouriteable_type } }, session: { account_id: @account.id }
	      expect(response.status).to eq 404
	    end

	    it 'returns an error message if there is an exception while creating the favourite' do
	      allow_any_instance_of(BxBlockFavourites::Favourite).to receive(:save).and_raise(Exception.new('Test exception'))
	      post :create, params: { data: {favourite_by_id: @account.id, favouriteable_id: favouriteable_id, favouriteable_type: favouriteable_type } }, session: { account_id: @account.id }
	      expect(response.status).to eq 422
	    end
  	end

	describe '#destroy' do
	    it 'deletes the specified favourite for the current user' do
	      favourite = BxBlockFavourites::Favourite.create!(favourite_by_id: @account.id, favouriteable_id: favouriteable_id,favouriteable_type: favouriteable_type)
	      delete :destroy, params: { id: favourite.id }, session: { account_id: @account.id }
	      expect(response.status).to eq 200
	    end

	    it 'returns an error message if the specified favourite cannot be found for the current user' do
	      delete :destroy, params: { id: 1 }, session: { account_id: @account.id }
	      expect(response.status).to eq 404
	    end
  	end
end
