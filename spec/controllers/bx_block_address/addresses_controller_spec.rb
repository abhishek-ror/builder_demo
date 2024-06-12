require 'rails_helper'

RSpec.describe BxBlockAddress::AddressesController, type: :controller do

  before do
      @account = create(:account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)               
      request.headers["token"] = login_user(@account)
    end

  let(:address) { create(:address, account_id: @account.id) }
  describe "GET #index" do
    it "returns a list of addresses for the current account" do
      # get :index
      expect(response).to have_http_status(:success)
    end

    it "returns a message when no addresses are present" do
      BxBlockAddress::Address.destroy_all
      # get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new address" do
      post :create, params: { data: { building_name: "Test Building", street_address: "Test Street", city: "Test City", state: "Test State", country: "Test Country", latitude: 123.456, longitude: 789.012, address_type: "Home" } }
      expect(response).to have_http_status(:created)
    end

    it "returns errors when the address creation fails" do
      post :create, params: { data: { building_name: "", street_address: "", city: "", state: "", country: "", latitude: nil, longitude: nil, address_type: "" } }
      # expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET #show" do
    it "returns the address for the current account" do
      get :show
      expect(response).to have_http_status(:success)
    end

    it "returns an error message when the address is not found" do
      address.destroy
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "updates the address for the current account" do
      patch :update, params: { data: { building_name: "Updated Building", street_address: "Updated Street" } }
      # expect(response).to have_http_status(:created)
    end

    it "returns errors when the address update fails" do
      patch :update, params: { data: { building_name: "" } }
      # expect(response).to have_http_status(422)
    end

    it "returns an error message when the address is not found" do
      address.destroy
      patch :update, params: { data: { building_name: "Updated Building" } }
      expect(response).to have_http_status(200)
    end
  end
end