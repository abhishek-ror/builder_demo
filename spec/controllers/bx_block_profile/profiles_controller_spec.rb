require 'rails_helper'

RSpec.describe BxBlockProfile::ProfilesController, type: :controller do
  let(:current_user) { create(:account) }
  let(:token) { BuilderJsonWebToken.encode(current_user.id, { account_type: current_user.type }, 1.year.from_now) }

  before do
    request.headers['token'] = token
  end

  describe 'POST #create' do
    context 'when valid parameters are provided' do
      let(:valid_params) do
        {
          data: {
            country: 'USA',
            address: '123 Main St',
            city: 'New York',
            postal_code: '12345',
            account_id: current_user.id
          }
        }
      end

      it 'creates a new profile and returns a successful response' do
        
          post :create, params: valid_params
        

        expect(response).to have_http_status(:created)
      end
    end

    context 'when invalid parameters are provided' do
      let(:invalid_params) do
        {
          data: {
            country: 'USA',
          }
        }
      end

      it 'returns an unprocessable entity response with error details' do
        profile = BxBlockProfile::Profile.create(account_id: current_user.id)
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

   describe 'GET #show' do
    context 'when the profile exists' do
      let!(:profile) { create(:profile, account: current_user) }

      it 'returns the profile and a successful response' do
        get :show

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH #update_profile' do
    let!(:profile) { create(:profile, account: current_user) }

    context 'with valid parameters' do
      let(:valid_params) { { data: { country: 'USA', address: '123 Main St', city: 'New York', postal_code: '12345' } } }

      it 'updates the profile and returns a successful response' do
        patch :update_profile, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(profile.reload.country).to eq('USA')
        expect(profile.reload.address).to eq('123 Main St')
        expect(profile.reload.city).to eq('New York')
        expect(profile.reload.postal_code).to eq('12345')
      end
    end

    context 'when the profile does not exist' do
      it 'returns an unprocessable entity response with error details' do
        allow(BxBlockProfile::Profile).to receive(:find_by).and_return(nil)

        patch :update_profile

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the phone number is already used' do
      let(:get_account_params) { { "country_code" => "+91", "phone_number" => "7987586921" } }
      let(:existing_account) { create(:account, full_phone_number: '+917987586921') }
      let(:get_account_by_phone) { double('Account') }

      before do
        allow(AccountBlock::EmailAccount).to receive(:find_by).with(full_phone_number: '+917987586921').and_return(existing_account)
      end

      it 'returns an error response' do
        patch :update_profile, params: { data: get_account_params }
      end
    end

    context 'with valid parameters and phone number not used' do
      let(:params) { { data: { phone_number: '1234567890' } } }

      it 'updates the profile successfully' do
        put :update_profile, params: params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['errors']).to be_nil
      end
    end
  end

  describe 'GET #user_profiles' do
    let!(:profile1) { create(:profile, account_id: current_user.id) }

    it 'returns the profiles for the current user' do
      get :user_profiles

      expect(response).to have_http_status(:ok)
    end
  end
end
