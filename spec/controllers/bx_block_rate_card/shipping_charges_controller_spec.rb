require 'rails_helper'

RSpec.describe BxBlockRateCard::ShippingChargesController, type: :controller do
    
  before do
    @account = create(:account)
    @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)           
    request.headers["token"] = login_user(@account)
  end

  describe 'GET #get_shipping_charges' do
    let!(:shipping_charge_1) { create(:shipping_charge, source_country: 'USA', destination_country: 'UK') }
    let!(:shipping_charge_2) { create(:shipping_charge, source_country: 'USA', destination_country: 'France') }
    
    it 'returns shipping charges for valid parameters' do
      get :get_shipping_charges, params: { data: { source_country: 'USA', destination_country: 'UK,France' } }
      expect(response).to have_http_status(:ok)
      
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['shipping_charges'].length).to eq(2)
    end

    it 'returns message for no available shipping charges' do
      get :get_shipping_charges, params: { data: { source_country: 'USA', destination_country: 'Germany' } }
      expect(response).to have_http_status(:ok)
      
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['shipping_charges'].length).to eq(1)
      expect(parsed_response['shipping_charges'][0]['data']['source_country']).to eq('USA')
      expect(parsed_response['shipping_charges'][0]['data']['destination_country']).to eq('Germany')
      expect(parsed_response['shipping_charges'][0]['data']['Message']).to eq('Data Not Available')
    end
  end

  describe 'GET #get_all_source_country' do
    let!(:shipping_charge_1) { create(:shipping_charge, source_country: 'USA') }
    let!(:shipping_charge_2) { create(:shipping_charge, source_country: 'UK') }
    
    it 'returns all source countries with available shipping charges' do
      get :get_all_source_country
      expect(response).to have_http_status(:ok)      
    end

    it 'returns message when no source countries available' do
      BxBlockRateCard::ShippingCharge.destroy_all
      get :get_all_source_country
      expect(response).to have_http_status(:ok)
      
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['message']).to eq('source_country are not available')
    end
  end

  describe 'GET #get_all_destination_country' do
    let!(:shipping_charge_1) { create(:shipping_charge, destination_country: 'UK') }
    let!(:shipping_charge_2) { create(:shipping_charge, destination_country: 'France') }
    
    it 'returns all destination countries with available shipping charges' do
      get :get_all_destination_country
      expect(response).to have_http_status(:ok)
    end

    it 'returns message when no destination countries available' do
      BxBlockRateCard::ShippingCharge.destroy_all
      get :get_all_destination_country
      expect(response).to have_http_status(:ok)
      
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['message']).to eq('Destination_countries are not available')
    end
  end

  describe 'GET #check_price_availability' do
    let!(:shipping_charge) { create(:shipping_charge, source_country: 'USA', destination_country: 'UK', destination_port: 'SomePort', price: 100, in_transit: 100) }

    it 'returns price if shipping charge is available' do
      get :check_price_availability, params: { source_country: 'USA', destination_country: 'UK', destination_port: 'SomePort' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ 'available' => true, 'price' => '100' })
    end


    it 'returns error message if shipping charge is not available' do
      get :check_price_availability, params: { source_country: 'USA', destination_country: 'UK', destination_port: 'NonExistentPort' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ 'available' => false, 'message' => 'The selected port is not available.' })
    end
  end
end