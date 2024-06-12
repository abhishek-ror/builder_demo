require 'rails_helper'
RSpec.describe  ::AccountBlock::Accounts::CountryCodeAndFlagsController, type: :controller do

	describe 'GET #show' do
	    it 'returns a list of country codes and flags' do
	      get :show
	      expect(response).to have_http_status(:success)
		end
    end

	describe 'GET #get_country_list' do
	    it 'returns a list of countries with their names and codes' do
	      get :get_country_list
	      expect(response).to have_http_status(:success)
		end
	end
end
