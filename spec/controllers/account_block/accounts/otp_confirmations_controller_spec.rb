require 'rails_helper'
RSpec.describe  ::AccountBlock::Accounts::OtpConfirmationsController, type: :controller do

	describe 'POST #create' do
		
	    before do
	      @account = create(:account)
	      @token = BuilderJsonWebToken.encode(@account.id, { account_type: @account.type }, 1.year.from_now)
	      @otp = AccountBlock::EmailOtp.create!(email: @account.email)
	      request.headers['token'] = @token
	    end

		context 'when the token and OTP code are valid' do
		  it 'destroys the OTP and renders a success response' do
		    post :create, params: { otp: @otp.pin }

		    expect(response).to have_http_status(:created)

		    json_response = JSON.parse(response.body)
		    expect(json_response['messages'][0]['otp']).to eq('OTP validation success')
		  end
		end

		context 'when the token has expired' do
		  let(:expired_token) { BuilderJsonWebToken.encode(@account.id, { account_type: @account.type }, 1.hour.ago) }

		  it 'renders an error response' do
		    request.headers['token'] = expired_token

		    post :create, params: { otp: @otp.pin }

		    expect(response).to have_http_status(:unauthorized)

		    json_response = JSON.parse(response.body)
		    expect(json_response['errors'][0]['pin']).to eq('OTP has expired, please request a new one.')
		  end
		end

		context 'when the token is invalid' do
		  it 'renders an error response' do
		    request.headers['token'] = 'invalid_token'

		    post :create, params: { otp: @otp.pin }

		    expect(response).to have_http_status(:bad_request)

		    json_response = JSON.parse(response.body)
		    expect(json_response['errors'][0]['token']).to eq('Invalid token')
		  end
		end

		context 'when the OTP is not found' do
		  it 'renders an error response' do
		    @otp.destroy

		    post :create, params: { otp: @otp.pin }

		    expect(response).to have_http_status(:unprocessable_entity)

		    json_response = JSON.parse(response.body)
		    expect(json_response['errors'][0]['otp']).to eq('OTP Not Found')
		  end
		end

		context 'when the OTP code is invalid' do
		  it 'renders an error response' do
		    post :create, params: { otp: 4321 }

		    expect(response).to have_http_status(:unprocessable_entity)

		    json_response = JSON.parse(response.body)
		    expect(json_response['errors'][0]['otp']).to eq('Invalid OTP code')
		  end
		end

		context 'when the token and OTP code are missing' do
		  it 'renders an error response' do
		    request.headers['token'] = nil

		    post :create, params: { otp: nil }

		    expect(response).to have_http_status(:unprocessable_entity)

		    json_response = JSON.parse(response.body)
		    expect(json_response['errors'][0]['otp']).to eq('Token and OTP code are required')
		  end
		end

		context 'when the account is not found' do
		  it 'renders an error response' do
		    allow(AccountBlock::Account).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

		    post :create, params: { otp: @otp.pin }

		    expect(response).to have_http_status(:unprocessable_entity)
		  end
		end
    end
end