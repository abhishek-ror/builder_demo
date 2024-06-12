require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::InspectionChargesController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @inspection_charge = create(:inspection_charge)
    sign_in @admin
  end

  describe 'POST#edit' do
        let!(:params) do {
          price: 1000
        } 
        end

        it 'edit a inspection charge' do
          put :edit, params: { id: @inspection_charge.id, inspection_charge: params }
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
      get :show, params: { id: @inspection_charge.id }
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
      expect(response.headers['Content-Disposition']).to include('inspection_charges_sample.csv')
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