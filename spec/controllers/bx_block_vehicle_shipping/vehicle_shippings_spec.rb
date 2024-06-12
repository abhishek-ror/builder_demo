require 'rails_helper'
require 'faker'

RSpec.describe BxBlockVehicleShipping::VehicleShippingsController, type: :controller do
	before do
    @account = create(:account)
    @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    @email_otp = AccountBlock::EmailOtp.create!(email: @account.email)
    request.headers["token"] = login_user(@account)
  end

  describe 'POST #create' do    
    context 'when shipment is valid' do
      it 'returns a success response with the shipment details' do      	
        post :create, params: { data: attributes_for(:vehicle_shipping) }
        message = JSON.parse(response.body)
        expect(message['Message']).to eq "shipment created successfully"
      end
    end
  end

  context 'get all shipment is valid' do
    before do
      @vehicle_shipping = FactoryBot.create(:vehicle_shipping)
    end
    it "while vehicle shipment and destination haldling not present" do
      get :show, params: {id: @vehicle_shipping.id}
      message = JSON.parse(response.body)
      # expect(message['shipment']).to eq 'Shipment/Destination not Found'
      # expect(response.status).to eq(404)
    end

    it "while vehicle shipment and destination haldling present" do
      # FactoryBot.create(:destination_handling)
      # FactoryBot.create(:shipping_carge)
      get :show, params: {id: @vehicle_shipping.id }
      message = JSON.parse(response.body)
      # expect(response.status).to eq(200)
    end            
  end

  describe 'PATCH #update' do 
    context 'when shipment is update' do
      it 'update a specific shipment' do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping)
        patch :update, params: { id: @vehicle_shipping.id, data: {country: 'Bali'} }
        message = JSON.parse(response.body)
        expect(message['message']).to eq 'shipment updated successfully..'
        expect(message['shipment']['data']['attributes']['country']).to eq 'Bali'
      end

      it 'update a specific shipment but record not found' do
        patch :update, params: { id: 0, data: {country: 'Bali'}}
        message = JSON.parse(response.body)
        expect(message['error']).to eq 'Invalid Id'
      end
    end
  end

  describe 'GET #get_user_shipment_list' do 
    context 'when shipment is update' do
      it 'get user shipment list with current user' do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping, account_id: @account.id)
        get :get_user_shipment_list
        expect(response.status).to eq 200
      end

      it 'get user shipment list with current user but not found' do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping, account_id: 0)
        get :get_user_shipment_list
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'Shipments not Found'
      end
    end
  end
  
  describe 'GET #all country' do 
    context 'when writtern all countries' do
      it 'get countries' do
        country = FactoryBot.create(:country)
        get :all_country
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #all port' do 
    context 'when writtern all ports' do
      it 'get ports' do
        country = FactoryBot.create(:country)
        get :port, params: {country_id: country.id}
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #get_final_invoice' do 
    context 'when get final invoice' do
      it 'get final shipment' do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping, account_id: @account.id)
        get :get_final_invoice, params: {id: @vehicle_shipping.id}
        expect(response.message).to eq 'OK'
      end
      it 'get final shipment but vehicle shipment not found' do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping, account_id: @account.id)
        get :get_final_invoice, params: {id: 0}
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'shipping not Found'
      end
    end
  end

  describe 'GET #admin_notes' do 
    context 'when get admin notes' do
      it 'get admin notes' do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping, account_id: @account.id)
        get :admin_notes, params: {id: 0}
        message = JSON.parse(response.body)
        expect(message['Message']).to eq 'notes for admin and other docuemnts are not found !'
      end
      it 'get admin notes' do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping, account_id: @account.id)
        get :admin_notes, params: {id: @vehicle_shipping.id, data: {notes_for_admin: 'test'}}
        message = JSON.parse(response.body)
        expect(message['Message']).to eq 'notes for admin & Other documents updated successfully'
      end
    end
  end
  describe 'GET #place_order' do 
    context 'when update vehicle shipment place order status' do
      it 'get updated vehicle shipping' do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping, account_id: @account.id)
        put :place_order, params: {shipment_id: @vehicle_shipping.id}
        message = JSON.parse(response.body)
        expect(message['message']).to eq 'Your request has been placed.Admin will update final shipping amount in the next 24 hours'
      end
      it 'vehicle shipment not found' do
        put :place_order, params: {shipment_id: 0}
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'Shipment not Found'
      end
    end
  end
  describe "#upload_receipt" do
    let(:shipment) { create(:vehicle_shipping) } # Assuming you have a factory for the VehicleShipping model

    context "when the shipment ID and receipt are present" do
      it "attaches the receipt to the shipment" do
        post :upload_receipt, params: { shipment_id: shipment.id, receipt: fixture_file_upload(Rails.root.join('app/assets/images/Privacy_Policy.pdf'), 'application/pdf') }
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'Receipt Uploaded'
      end

      it "Shipment or receipt is missing" do
        post :upload_receipt, params: { shipment_id: 0 }
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'Shipment or receipt is missing'
      end
    end
  end

  describe "#upload_customer_receipt" do
    let(:shipment) { create(:vehicle_shipping) } # Assuming you have a factory for the VehicleShipping model

    context "when the shipment ID and customer receipt are present" do
      it "attaches the receipt to the shipment" do
        put :upload_customer_receipt, params: {data: { shipment_id: shipment.id, customer_payment_receipt: fixture_file_upload(Rails.root.join('app/assets/images/test-image.png'), 'image/png') }}
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'Customer Receipt Uploaded'
      end

      it "Shipment or receipt is missing" do
        put :upload_customer_receipt, params: {data:{ shipment_id: 0 }}
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'Shipment or receipt is missing'
      end
    end
  end


  describe "#get_proof_of_delivery" do
    let(:shipment) { create(:vehicle_shipping) } # Assuming you have a factory for the VehicleShipping model

    context "when the delivery proofs are present" do
      it "attaches the receipt to the shipment" do
        get :get_proof_of_delivery, params: {id: shipment.id}
        message = JSON.parse(response.body)
        expect(message['status']).to eq 200
      end

      it " delivery proofs is missing" do
        get :get_proof_of_delivery, params: {id: 0}
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'Shipment or receipt is missing'
      end
    end
  end

  describe "#order_details" do
    let(:shipment) { create(:vehicle_shipping) } # Assuming you have a factory for the VehicleShipping model

    context "when the order_details are present" do
      it "attaches the receipt to the shipment" do
        get :order_details, params: {id: shipment.id}
        message = JSON.parse(response.body)
        expect(message['status']).to eq 200
      end

      it " order_details is missing" do
        get :order_details, params: {id: 0}
        message = JSON.parse(response.body)
        expect(message['shipment']).to eq 'Shipment or receipt is missing'
      end
    end
  end

  describe '#shipping cancelled get api' do
    let!(:account) { @account }
    
    before do
      request.headers["token"] = login_user(account)
    end

    it 'shipping request cancelled' do
      shipment = BxBlockVehicleShipping::VehicleShipping.create(status: "cancelled", year: 2012)
      get :shipping_cancelled, params: {id: shipment.id}
      shipment.reload

      expect(shipment.status).to eq("cancelled")
      expect(shipment.cancelled_at).to be_present
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.code)).to eq(200)
    end

    it 'shipping request not found' do
      get :shipping_cancelled
      expect(JSON.parse(response.code)).to eq(404)
    end
  end

end