require 'rails_helper'

RSpec.describe BxBlockReviews::AppReviewsController, type: :controller do
    
    before do
      @account = create(:account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)               
      request.headers["token"] = login_user(@account)
    end

    let(:invalid_attributes) { { data: { rating: 6, description: 'Too good to be true' } } }
    
    describe 'POST #create' do
      context 'when valid parameters are provided' do
        it 'renders the created review' do
          post :create, params: {data: {rating: 5 , account_id: @account.id, description: "Nice"}} 
          expect(response).to have_http_status(:created)
        end
      end
      context 'when invalid parameters are provided' do
        it 'renders an error message' do
          post :create, params: invalid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
end