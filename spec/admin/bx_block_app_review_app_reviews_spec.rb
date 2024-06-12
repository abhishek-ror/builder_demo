require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::RatingsController, type: :controller do


	render_views

    before(:each) do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Admin')
        @admin = create(:admin_user)
        sign_in @admin
    end

    describe 'GET#index' do
        it 'shows all labels' do
          get :index 
          expect(response).to have_http_status(200)
        end 
    end
    
end