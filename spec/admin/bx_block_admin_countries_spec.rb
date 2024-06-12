require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::CountriesController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @country = create(:country)
    sign_in @admin
  end

  describe 'POST#edit' do
        let!(:params) do {
          offer: "afddk"
        } 
        end

        it 'edit a Countries' do
          put :edit, params: { id: @country.id, country: params }
          expect(response).to have_http_status(200)
        end 
  end


  # describe 'GET#index' do
  #   it 'renders the index template' do
  #     get :index
  #     expect(response).to render_template(:index)
  #     expect(response).to have_http_status(200)
  #   end
  # end

  describe 'GET#show' do
    it 'renders the show template' do
      get :show, params: { id: @country.id }
      expect(response).to render_template(:show)
      expect(response).to have_http_status(200)
    end
  end
end