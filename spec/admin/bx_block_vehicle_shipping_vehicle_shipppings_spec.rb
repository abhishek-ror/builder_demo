require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::VehicleShippingsController, type: :controller do

	render_views

    before(:each) do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Admin')
        @admin = create(:admin_user)
        @service_shipping = ServiceShipping.create(title: "Accept shipping & close the order")
        @vehicle_shipping = create(:vehicle_shipping, service_shippings_id: @service_shipping.id)
        sign_in @admin
    end

    describe "Get#show" do
	    it "show shipping details" do
	      get :show, params: {id:  @vehicle_shipping.id}
	      expect(response).to have_http_status(200)
	    end
  	end

  	describe 'GET#index' do
        it 'shows all labels' do
          get :index 
          expect(response).to have_http_status(200)
        end 
    end

    describe 'POST#edit' do
	    let!(:params) do {
	      tracking_ling: "www.mytrck.com"
	    } 
	    end

	    it 'edit a account' do
	      put :edit, params: { id: @vehicle_shipping.id, vehicle_shippings: params }
	      expect(response).to have_http_status(200)
	    end 
  	end
end