require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::ServicesController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @service = BxBlockServices::Service.create(title: "title", description: "description")
    sign_in @admin
  end 
   
  describe 'POST#edit' do
    let!(:params) do {
      title: "rrrr", 
      description: "jfgjfgjfklgj",
    } 
    end

    it 'edit a account' do
      put :edit, params: { id: @service.id, service: params }
      expect(response).to have_http_status(200)
    end 
  end

  describe 'GET#index' do
    it 'shows all data' do
      get :index 
      expect(response).to have_http_status(200)
    end 

    it 'returns success if request format is CSV' do
      get :index, format: :csv
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET#show' do
    it 'show user detail' do
      get :show, params: { id: @service.id }
      expect(response).to have_http_status(200)
    end
  end

end