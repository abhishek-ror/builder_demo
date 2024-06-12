require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::SubscriptionPlansController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @plan = create(:plan)
    sign_in @admin
  end

  describe 'POST#edit' do
        let!(:params) do {
          price: 600.0
        } 
        end

        it 'edit a plan' do
          put :edit, params: { id: @plan.id, plan: params }
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
      get :show, params: { id: @plan.id }
      expect(response).to render_template(:show)
      expect(response).to have_http_status(200)
    end
  end
end