require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::RegionalSpecsController, type: :controller do
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
            
    } 
    end

    it 'creates a regional spec' do
      post :new, params: params
      expect(response).to have_http_status(200)
    end 
  end

  describe 'GET#index' do
        it 'shows all labels' do
          get :index 
          expect(response).to have_http_status(200)
        end 
    end
end 