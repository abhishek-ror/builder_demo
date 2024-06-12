require 'rails_helper'
RSpec.describe  ::AccountBlock::AccountsController, type: :controller do
  # RSpec.describe ::BxBlockPosts::VehicleInspectionsController, type: :controller do
  let(:params_data){{ "data": { "attributes": {"full_name": "Ritesh Kumar","phone_number": "9878315980","email": "ritesh21@abc.com","country_code": "+91","country": "India","terms_and_conditions": true}}}}
  describe '#create' do
    it 'should pass when Create Successfully' do
      post :create, params: params_data
      expect(JSON.parse(response.code)).to eq(201)
    end
    it 'should pass when not Created Successfully' do
      post :create, params: { "data": { "attributes": { "full_name": "FullName", "email": "" } } }
      expect(JSON.parse(response.body)["status"]).to eq(400)
    end
  end

  describe "get_term_and_condition" do
    let!(:account) { create(:account) }
    before do
        request.headers["token"] = login_user(account)
    end
    it "should get terms and conditions status" do
      get :get_term_and_condition
      expect(JSON.parse(response.body)["status"]).to eq(true)
    end
  end

  describe "update_term_and_condition" do
    let!(:account) { create(:account) }
    before do
        request.headers["token"] = login_user(account)
    end
    it "should get terms and conditions status" do
      patch :update_term_and_condition, params: {response: true}
      expect(JSON.parse(response.body)["message"]).to eq("Terms and condition updated!")
    end
  end

  describe "delete_account" do
    let!(:account) { create(:account) }
    before do
        request.headers["token"] = login_user(account)
    end
    it "should delete the account" do
      delete :delete_account
      expect(JSON.parse(response.body)["message"]).to eq("#{account.full_name} deleted permanently")
    end
  end


  describe "delete_account_with_id" do
    let!(:account) { create(:account) }
    it "should delete the account using email" do
      get :delete_account_with_id, params: {email: account.email}
      expect(JSON.parse(response.body)["message"]).to eq("#{account.full_name} deleted permanently")
    end

    it "should not delete the account using email" do
      get :delete_account_with_id, params: {email: 'abc@email.com'}
      expect(JSON.parse(response.body)["message"]).to eq("abc@email.com email not found")
    end
  end

end
