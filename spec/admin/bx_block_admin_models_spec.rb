require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::CarModelsController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @model = create(:model)
    sign_in @admin
  end

  describe 'POST#edit' do
        let!(:params) do {
          name: "Audi"
        } 
        end

        it 'edit a model' do
          put :edit, params: { id: @model.id, model: params }
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
      get :show, params: { id: @model.id }
      expect(response).to render_template(:show)
      expect(response).to have_http_status(200)
    end
  end
end