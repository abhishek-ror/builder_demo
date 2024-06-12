require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::TermsAndConditionsController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @city = create(:city)
    @model = create(:model)
    @trim = create(:trim, model_id: @model.id)
    @termscondition = BxBlockAdmin::TermsAndCondition.create(description: "description")
    sign_in @admin
  end

  describe 'POST#new' do
    let!(:params) do {
         engine_type: {
          name: 'V6',
          engine_type: 'Fuel Type'
        }   
    } 
    end

    it 'creates a banner' do
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

  describe 'GET new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

   describe 'GET#show' do
    it 'show user detail' do
      get :show, params: { id: @termscondition.id }
      expect(response).to have_http_status(200)
    end
  end
end