require 'rails_helper'
RSpec.describe AccountBlock::AccountsController, type: :controller do

    describe 'POST create' do

        before(:each) do
            @account = create(:account)
        end

        context "when pass valid params" do

            it 'Returns success' do
                post :create, params: { data: { type: @account.type, attributes: {first_name: @account.first_name, full_phone_number: "+918976543212", country_code: @account.country_code, country: @account.country, phone_number: "8976543212", email: "test@yopmail.com", password_digest: @account.password_digest, user_type: @account.user_type, status: @account.status } } }
                expect(response).to have_http_status(201)
            end

        end

    end

    describe "Get search" do
        
        before do
            account = create(:account)
            @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
        end
        
        context "when pass valid params" do

          it "return List of users." do
            get :search, params: {use_route: '/accounts', token: @token}
            expect(response).to have_http_status(200)
          end

        end

    end

    describe "Get activate account" do
        
        before do
            account = create(:account)
            @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
        end
        
        context "when activate account" do

            it "Your Account Is Activated" do
                get :activate_account, params: {token: @token}
                expect(response).to have_http_status(200)
            end 
        end

    end

    describe "Send_otp_to_admin_email" do

        before do
            @account = create(:account)
            @token = BuilderJsonWebToken.encode(@account.id, 15.minutes.from_now)
        end
        
        context "when create account" do

            it "OTP Sent To admin Email Successfully" do
                post :send_otp_to_admin_email, params: {email: @account.email} 
                expect(response).to have_http_status(200)
            end

        end

    end

end