require 'rails_helper'

RSpec.describe BxBlockAdvertisement::AdvertisementsController, type: :controller do
  describe 'GET advertisement_lists' do
    context 'when advertisements are present' do
      let!(:advertisements) { create_list(:advertisement, 3) }

      it 'returns a list of advertisements' do
        get :advertisement_lists
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response['Advertisements']).to be_present
      end
    end

    context 'when no advertisements are available' do
      it 'returns a message indicating no advertisements available' do
        get :advertisement_lists
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response['Message']).to eq('No Advertisement available')
      end
    end
  end
end