require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

RSpec.describe ServiceShippingController, type: :controller do
	before do
    @account = create(:account)
    @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    @email_otp = AccountBlock::EmailOtp.create!(email: @account.email)
    request.headers["token"] = login_user(@account)
  end

	describe 'GET#index' do
		it 'shows all destination service' do
			get :index 
			expect(response).to have_http_status(200)
		end
	end
end