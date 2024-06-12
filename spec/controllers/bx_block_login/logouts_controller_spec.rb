require 'rails_helper'
RSpec.describe BxBlockLogin::LogoutsController, type: :controller do
  describe 'DELETE #destroy' do
    before do
      @account = create(:account)
      @token = BuilderJsonWebToken.encode(@account.id, { account_type: @account.type }, 1.year.from_now)
      request.headers['token'] = @token
    end
    it 'logs out the user and renders a success response' do
      delete :destroy
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response['meta']['message']).to eq('Logout Successfully..')
      expect(json_response['meta']['account']).to be_present
      expect(json_response['meta']['token']).to be_present
    end

    it 'returns an error if the token is invalid' do
      request.headers['token'] = 'invalid_token'
      delete :destroy
      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to be_present
      expect(json_response['errors'][0]['token']).to eq('Invalid token')
    end

    it 'returns a message if JWT decoding raises an error' do
      allow(BuilderJsonWebToken).to receive(:decode).and_raise(JWT::DecodeError)
      delete :destroy
      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to be_present
      expect(json_response['errors'][0]['token']).to eq('Invalid token')
    end
  end
end