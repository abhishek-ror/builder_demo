require 'rails_helper'

RSpec.describe BxBlockForgotPassword::EmailValidationsController, type: :controller do
  describe 'POST create' do
    let!(:account) { create(:account) }

    context 'when email is provided' do
     
      it 'sends a verification email and returns a success response' do
         post :create, params: {
          data: {
            attributes: {
              email: account.email
            }
          }
        }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Verification Link sent to your Email Successfully')
      end
    end

    context 'when email is not provided' do
      it 'returns an error response' do
        post :create, params: {
          data: {
            email: ''
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Email required')
      end
    end

    context 'when account is not found' do
      before do
        allow(AccountBlock::EmailAccount).to receive(:where).and_return(AccountBlock::EmailAccount)
        allow(AccountBlock::EmailAccount).to receive(:first).and_return(nil)
      end

      it 'returns a not found response' do
        post :create, params: {
          data: {
            attributes: {
              email: 'fdjkj@g.com'
            }
          }
        }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Account not found')
      end
    end
  end
end
