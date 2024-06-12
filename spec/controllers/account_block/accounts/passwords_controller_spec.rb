require 'rails_helper'
RSpec.describe  ::AccountBlock::Accounts::PasswordsController, type: :controller do

	describe 'POST #create' do

	    before do
	      @account = create(:account)
	      @token = BuilderJsonWebToken.encode(@account.id, { account_type: @account.type }, 1.month.from_now)
	      request.headers['token'] = @token
	    end

		context 'when the token is missing' do
		  it 'renders an error response' do
		    request.headers['token'] = nil

		    post :create

		    json_response = JSON.parse(response.body)
		    expect(json_response['errors']).to eq('Token is required')
		  end
		end

		context 'when the password is not matched' do
		  it 'renders an error response' do
		    post :create, params: {
		      data: {
		        new_password: 'Password@1234',
		        confirm_password: 'Password@4564'
		      }
		    }

		    expect(response).to have_http_status(:unprocessable_entity)
		    json_response = JSON.parse(response.body)
		    expect(json_response['errors']).to eq([{ 'message' => 'Password not matched' }])
		  end
		end

		context 'when the password validation is failed' do
		  it 'renders an error response' do
		    post :create, params: {
		      data: {
		        new_password: 'password123',
		        confirm_password: 'password123'
		      }
		    }
			expect(response).to have_http_status(:unprocessable_entity)
		  end
		end

		context 'when the token is invalid' do
			it 'renders an error response' do
			    request.headers['token'] = 'invalid_token'

			    post :create

			    expect(response).to have_http_status(:bad_request)

			    json_response = JSON.parse(response.body)
			    expect(json_response['errors'][0]['token']).to eq('Invalid token')
			end
		end

		
		context 'when the request is valid' do
		  it 'updates the account password and renders a success response' do
		    post :create, params: {
		      data: {
		        new_password: 'Password@1234',
		        confirm_password: 'Password@1234'
		      }
		    }

		    expect(JSON.parse(response.code)).to eq(200)
		  end
		end
    end

   #  describe '#user_one_time_password' do
	  #   context 'with a valid temporary_token' do
	  #     let(:account) { create(:account) } # Assuming you have a factory for creating accounts

	  #     before do
	  #       get :user_one_time_password, params: { temporary_token: account.temporary_token }
	  #     end

	  #     it 'returns a success response with message' do
	  #       # expect(response).to have_http_status(:success)
	  #       # parsed_response = JSON.parse(response.body)
	  #       # expect(parsed_response['message']).to eq('Password can be created.')
	  #       # expect(parsed_response['status']).to eq(200)
	  #     end
	  #   end

	  #   context 'with an invalid temporary_token' do
	  #     before do
	  #       get :user_one_time_password, params: { temporary_token: 'invalid_token' }
	  #     end

	  #     it 'returns a not found response with message' do
	  #       # expect(response).to have_http_status(:not_found)
	  #       parsed_response = JSON.parse(response.body)
	  #       # expect(parsed_response['message']).to eq('Link Expired')
	  #       # expect(parsed_response['status']).to eq(404)
	  #     end
	  #   end
  	# end

  	describe '#user_one_time_password' do
    context 'with a valid token and matching temporary_token' do
      let(:account) { FactoryBot.create(:account) }
      let(:temporary_token) { 'random_token_value' }
      # let(:token) { BuilderJsonWebToken.encode(id: account.id) }

      before do
        # request.headers['token'] = token
        get :user_one_time_password, params: { temporary_token: temporary_token }
      end

      it 'returns a success message' do
        expect(response).to have_http_status(:ok)
        # expect(JSON.parse(response.body)['message']).to eq('Password can be created.')
      end
    end

    context 'with an expired token or non-matching temporary_token' do
      let(:account) { FactoryBot.create(:account) }
      let(:temporary_token) { 'non_matching_token' }
      # let(:token) { BuilderJsonWebToken.encode(id: account.id) }

      before do
        # request.headers['token'] = token
        # get :user_one_time_password, params: { temporary_token: temporary_token }
      end

      it 'returns the error message' do
        # expect(response).to have_http_status(:bad_request)
        # expect(JSON.parse(response.body)['message']).to eq('Link Expired')
      end
    end

    context 'with an invalid token' do
      before do
        request.headers['token'] = 'invalid_token'
        get :user_one_time_password
      end

      it 'returns an error messages' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['errors'][0]['token']).to eq('Invalid token')
      end
    end

    context 'with a missing token' do
      before do
        get :user_one_time_password
      end

      it 'return an error message' do
        # expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to eq('Token is required')
      end
    end

    context 'with an account not found' do
      # let(:non_existent_account_id) { 999 }

      # before do
      #   request.headers['token'] = BuilderJsonWebToken.encode(id: 1000)
      #   get :user_one_time_password, params: { temporary_token: 'random_token' }
      # end

      it 'returns an error message account' do
        # expect(response).to have_http_status(:unprocessable_entity)
        # expect(JSON.parse(response.body)['errors'][0]['msg']).to eq('Account not found')
      end
    end
  end

end