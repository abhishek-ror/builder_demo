require 'rails_helper'

RSpec.describe BxBlockLocation::LocationsController, type: :controller do

  let(:current_user) { create(:account) }
  let(:token) { BuilderJsonWebToken.encode(current_user.id, { account_type: current_user.type }, 1.year.from_now) }

  before do
    request.headers['token'] = token
  end
  
  describe 'GET #region_list' do
    it 'returns a list of regions' do
      get :region_list
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['success']).to be true
      expect(JSON.parse(response.body)['data']).to be_an(Array)
    end
  end

  describe 'GET #country_list' do
    context 'when region_id is present' do
      let(:region) { create(:region) }

      it 'returns a list of countries for the specified region' do
        get :country_list, params: { region_id: region.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['success']).to be true
        expect(JSON.parse(response.body)['data']).to be_an(Array)
      end
    end

    context 'when region_id is missing' do
      it 'returns an error message' do
        get :country_list
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to eq('Region Id is missing')
      end
    end
  end

  describe 'GET #state_list' do
    context 'when country_id is present' do
      let(:country) { create(:country) }

      it 'returns a list of states for the specified country' do
        get :state_list, params: { country_id: country.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['success']).to be true
        expect(JSON.parse(response.body)['data']).to be_an(Array)
      end
    end

    context 'when country_id is missing' do
      it 'returns an error message' do
        get :state_list
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to eq('Country Id is missing')
      end
    end
  end

  describe 'GET #area_list' do
    context 'when state_id is present' do
      let(:state) { create(:state) }

      it 'returns a list of areas for the specified state' do
        get :area_list, params: { state_id: state.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['success']).to be true
        expect(JSON.parse(response.body)['data']).to be_an(Array)
      end
    end

    context 'when state_id is missing' do
      it 'returns an error message' do
        get :area_list
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to eq('State Id is missing')
      end
    end
  end
end
