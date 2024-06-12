require 'rails_helper'
RSpec.describe BxBlockLogin::LoginsController, type: :controller do

	describe 'POST create' do
		let!(:account) { create(:account) }
		let(:account_data) do
	      {
	        type: 'email_account',
	        attributes: {
	          email: account.email,
	          password: account.password,
	          fcm_device_token: 'test_fcm_token'
	        }
	      }
	    end

		context 'When not login' do
		  
		  it 'renders unprocessable entity status for account not found' do
		    allow(AccountBlock::Account).to receive(:new).and_return(nil)

		    post :create, params: { data: account_data }

		    expect(response).to have_http_status(:unprocessable_entity)
		    expect(response.body).to include('Account not found or not activated')
		  end
		end

		context 'when account type is invalid' do
		  it 'renders unprocessable entity status' do
		    post :create, params: { data: { type: 'invalid_account' } }

		    expect(response).to have_http_status(:unprocessable_entity)
		    expect(response.body).to include('Invalid Account Type')
		  end
		end


	     context 'when account type is valid' do
	      let(:output) { instance_double(BxBlockLogin::AccountAdapter) }
	      let(:token) { 'jwt_token' }
	      let(:refresh_token) { 'refresh_token' }

	      before do
	        allow(BxBlockLogin::AccountAdapter).to receive(:new).and_return(output)
	        allow(output).to receive(:on)
	      end

	      it 'returns the account, token, and refresh_token on successful login' do
	        expect(output).to receive(:login_account).with(kind_of(OpenStruct)).and_return(nil)
	        expect(output).to receive(:on).with(:successful_login).and_yield(account, token, refresh_token)

	        post :create, params: { data: account_data }

	        expect(response).to have_http_status(:ok)
	        expect(response.body).to include(account.to_json)
	        expect(response.body).to include(token)
	        expect(response.body).to include(refresh_token)
	      end

	      it 'renders unauthorized status for failed login' do
	        expect(output).to receive(:login_account).with(kind_of(OpenStruct)).and_return(nil)
	        expect(output).to receive(:on).with(:failed_login).and_yield(account)

	        post :create, params: { data: account_data }

	        expect(response).to have_http_status(:unauthorized)
	        expect(response.body).to include('Your password is incorrect')
	      end
	    end
    end		
end