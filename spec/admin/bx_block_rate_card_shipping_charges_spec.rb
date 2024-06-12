require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::ShippingChargesController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @shipping_carge = create(:shipping_carge)
    sign_in @admin
  end

  describe 'POST#edit' do
        let!(:params) do {
          price: "1000"
        } 
        end

        it 'edit a shipping carge' do
          put :edit, params: { id: @shipping_carge.id, shipping_carge: params }
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
      get :show, params: { id: @shipping_carge.id }
      expect(response).to render_template(:show)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET#index' do
    it 'renders the index template' do
      get :index, format: :csv
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq 'text/csv; charset=utf-8'
    end
  end

  describe 'GET#download_csv_sample' do
    it 'downloads the CSV sample file' do
      get :download_csv_sample
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq 'text/csv '
      expect(response.headers['Content-Disposition']).to include('attachment')
      expect(response.headers['Content-Disposition']).to include('shipping_charges_sample.csv')
    end
  end

  describe 'GET#import' do
    it 'displays the import page' do
      get :import
      expect(response).to have_http_status(200)
      expect(response).to render_template(:import)
    end
  end

end