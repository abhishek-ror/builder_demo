require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::RegionsController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @region = create(:region)
    sign_in @admin
  end

  describe 'POST#edit' do
        let!(:params) do {
          name: "USA"
        } 
        end

        it 'edit a region' do
          put :edit, params: { id: @region.id, region: params }
          expect(response).to have_http_status(200)
        end 
  end


  describe 'GET#index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET#show' do
    it 'renders the show template' do
      get :show, params: { id: @region.id }
      expect(response).to render_template(:show)
      expect(response).to have_http_status(200)
    end
  end
end