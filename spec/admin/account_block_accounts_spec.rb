require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::AccountsController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    sign_in @admin
  end 
   
  describe 'POST#edit' do
    let!(:params) do {
      first_name: "jivesh", 
      email: ("jivan@gmail.com"), 
      full_phone_number: "917860052340", 
      country: "India"
    } 
    end

    it 'edit a account' do
      put :edit, params: { id: @account.id, accounts: params }
      expect(response).to have_http_status(200)
    end 
  end

  describe 'GET#index' do
    it 'shows all data' do
      get :index 
      expect(response).to have_http_status(200)
    end 

    it 'returns success if request format is CSV' do
      get :index, format: :csv
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET#show' do
    it 'show user detail' do
      get :show, params: { id: @account.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE#remove' do
    it 'remove account' do
      get :remove, params: { id: @account.id }
      expect(flash[:notice]).to match("Account was successfully destroyed.")
    end
  end
end