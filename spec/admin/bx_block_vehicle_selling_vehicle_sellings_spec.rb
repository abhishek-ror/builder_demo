require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::VehicleSellingsController, type: :controller do

    render_views

    before(:each) do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Admin')
        @admin = create(:admin_user)
        @account = create(:account)
        @country = create(:country)
        @city = create(:city)
        @model = create(:model)
        @trim = create(:trim ,model_id: @model.id)
        @state = create(:state)
        @region = create(:region)
        @selling = BxBlockVehicleShipping::VehicleSelling.create!(account_id: @account.id, city_id: @city.id, trim_id: @trim.id, region_id: @region.id, country_id: @country.id,state_id: @state.id, price: "100", make: "Tesla", kms: "5", no_of_cylinder: 1, no_of_doors: 4, horse_power: 10, year: 2012, verified: true)
        sign_in @admin
    end

    describe 'GET#index' do
        it 'shows all labels' do
          get :index 
          expect(response).to have_http_status(200)
        end 
    end

    describe "Get#show" do
    it "show account" do
      get :show, params: {id:  @selling.id}
      expect(response).to have_http_status(200)
    end

    describe 'POST#edit' do
        let!(:params) do {
          price: "10,000"
        } 
        end

        it 'edit a account' do
          put :edit, params: { id: @selling.id, vehilcle_sellings: params }
          expect(response).to have_http_status(200)
        end 
    end
  end
end





