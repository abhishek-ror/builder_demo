require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::CarAdsController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @city = create(:city)
    @model = create(:model)
    @trim = create(:trim, model_id: @model.id)
    sign_in @admin
  end 
   
  describe 'POST#new' do
    let!(:params) do {
      city_id: @city.id,
      trim_id: @trim.id,
      account_id: @account.id
    } 
    end

    it 'creates a car_ads' do
      post :new, params: params
      expect(response).to have_http_status(200)
    end 
  end

  describe 'GET#index' do
    it 'shows all car_ads' do
      get :index 
      expect(response).to have_http_status(200)
    end 
  end

  describe 'GET#show' do
    let!(:account) { create(:account) }
    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
    let!(:company) { create(:company) }
    let!(:model) { create(:model, company: company) }
    let!(:region) { create(:region) }
    let!(:country) { create(:country, region: region) }
    let!(:state) { create(:state, country: country) }
    let!(:city) { create(:city, state: state) }
    let!(:car_ad) { create(:car_ad, city: city, account: account, trim: @trim) }
    it 'show car_ads' do
      get :show, params: { id: car_ad.id }
      expect(response).to have_http_status(200)
    end
  end
end
