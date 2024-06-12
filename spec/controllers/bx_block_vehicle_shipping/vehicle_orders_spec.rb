require 'rails_helper'

RSpec.describe BxBlockVehicleShipping::VehicleOrdersController, type: :controller do
    before do  
    @account = create(:account)
    @country = create(:country)
    @city = create(:city)
    @model = create(:model)
    @trim = create(:trim ,model_id: @model.id)
    @state = create(:state)
    @region = create(:region)
    @plan = create(:plan)
    @plan = create(:bx_block_plan_user_subscription, plan: @plan, account: @account)
    @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)               
    @email_otp = AccountBlock::EmailOtp.create!(email: @account.email)
    @rate = BxBlockRateCard::InspectionCharge.create(country: @country.name, region: @region.name, price: 1000)
    @selling = BxBlockVehicleShipping::VehicleSelling.create!(account_id: @account.id, city_id: @city.id, trim_id: @trim.id, region_id: @region.id, country_id: @country.id,state_id: @state.id, price: "100", make: "Tesla", kms: "5", no_of_cylinder: 1, no_of_doors: 4, horse_power: 10, year: 2010)
    @selling_token = BuilderJsonWebToken.encode(@email_otp.id, 5.minutes.from_now, type: @email_otp.class, selling_id: @selling.id)
    @vehicle_order = BxBlockVehicleShipping::VehicleOrder.create!(continent: "Asia", country: "India", state: "Kuch bhi", area: "Madurai", country_code: @account.country_code, phone_number: @account.phone_number, full_phone_number: @account.full_phone_number, account_id: @account.id, status: 3, vehicle_selling_id: @selling.id, instant_deposit_amount: 100, final_sale_amount: 100)
    @vehicle_shipping = FactoryBot.create(:vehicle_shipping)
    request.headers["token"] = login_user(@account)
    @car_ad1 = FactoryBot.create(:car_ad, city: @city, account: @account, trim: @trim)
    @vehicle_order1 = BxBlockVehicleShipping::VehicleOrder.create!(continent: "Asia", country: "India", state: "Kuch bhi", area: "Madurai", country_code: @account.country_code, phone_number: @account.phone_number, full_phone_number: @account.full_phone_number, account_id: @account.id, status: 3, car_ad_id: @car_ad1.id, instant_deposit_amount: 100, final_sale_amount: 100)
  end

  describe 'create' do 
    let!(:account) { @account }
    let!(:selling) { @selling }

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        post :create, params: {data: {continent: "Asia", country: "India", state: "Tamilnadu", area: "Madurai", country_code: "+91", phone_number: "8012136009", vehicle_selling_id: selling.id}}
      end
      it 'When user vehicle order is created' do
        # expect(JSON.parse(response.body)["meta"]['message']).to eq("Your details have been submitted to the admin,they will contact you shortly")
        # expect(response.code).to eq('200')
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        post :create, params: {data: {continent: "Asia", country: "India", state: "Tamilnadu", area: "Madurai", country_code: "+91", phone_number: "801213600", vehicle_selling_id: selling.id}}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["error"]).to eq("Phone Number Invalid")
        expect(response.code).to eq('422')
      end 
    end

    # context 'save' do
    #   before do
    #     request.headers["token"] = login_user(account)
    #     post :create, params: {data: {country: "India", state: "Tamilnadu", area: "Madurai", country_code: "+91", phone_number: "8012136009", vehicle_selling_id: selling.id}}
    #   end
    #   it 'When user vehicle order is created' do
    #     expect(JSON.parse(response.body)["errors"].first["continent"]).to eq("can't be blank")
    #   end 
    # end
  end

  describe 'request_inspection' do 
    let!(:account) { @account }
    let!(:selling) { @selling }
    let!(:vehicle_order) {@vehicle_order}
    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: @account) }
    let!(:car_ad) { create(:car_ad, city: @city, account: @account, trim: @trim) }
    context 'request_inspection' do
      before do
        request.headers["token"] = login_user(account)
        post :request_inspection, params: { order_request_id: @vehicle_order.order_request_id, card: { number: "4242424242424242", month: "12", year: "2023", cvc: "123" } }
      end
      it 'When user vehicle order is created' do
        expect(response.code).to eq('200')
      end 
    end

    context 'request_inspection' do
      before do
        request.headers["token"] = login_user(account)
        post :request_inspection, params: { car_ad_id: car_ad.id, card: { number: "4242424242424242", month: "12", year: "2023", cvc: "123" } }
      end
      it 'When user vehicle order is created' do
        expect(response.code).to eq('200')
      end 
    end

    context 'request_inspection' do
      before do
        request.headers["token"] = login_user(account)
        post :request_inspection, params: { selling_id: @selling.id, card: { number: "4242424242424242", month: "12", year: "2023", cvc: "123" } }
      end
      it 'When vehicle selling is created' do
        expect(response.code).to eq('200')
      end 
    end

    context 'request_inspection' do
      before do
        request.headers["token"] = login_user(account)
        post :request_inspection, params: {card: { number: "4242424242424242", month: "12", year: "2023", cvc: "123" } }
      end
      it 'When vehicle selling is created' do
        expect(response.code).to eq('422')
      end 
    end
  end


  describe 'get_order' do 
    let!(:account) { @account }
    let!(:selling) { @selling }
    let!(:vehicle_order) {@vehicle_order}
    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_order, params: {}
      end
      it 'When user vehicle order is created' do
        expect(response.code).to eq('422')
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_order, params: {order_request: "aaaaaa"}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["message"]).to eq("Required inputs missing")
        expect(response.code).to eq('422')
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_order, params: {order_request_id: @vehicle_order.order_request_id}
      end
      it 'When user vehicle order is created' do
        expect(response.code).to eq('200')
      end 
    end
  end


  describe 'get_order' do 
    let!(:account) { @account }
    let!(:selling) { @selling }
    let!(:vehicle_order) {@vehicle_order}
    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_documents, params: {order_request_id: @vehicle_order.order_request_id}
      end
      it 'When user vehicle order is created' do
        expect(response.code).to eq('200')
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_documents, params: {order_request: "aaaaaa"}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["message"]).to eq("Order not Found")
        expect(response.code).to eq('404')
      end 
    end
  end

  describe 'get_order_details' do 
    let!(:account) { @account }
    let!(:selling) { @selling }
    let!(:vehicle_order) {@vehicle_order}
    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_order_details, params: {}
      end
      it 'When user vehicle order is created' do
        expect(response.code).to eq('422')
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_order_details, params: {order_request: "aaaaaa"}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["message"]).to eq("Required inputs missing")
        expect(response.code).to eq('422')
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_order_details, params: {order_request_id:  vehicle_order.order_request_id}
      end
      it 'When user vehicle order is created' do
        expect(response.code).to eq('200')
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        vehicle_order.update(vehicle_shipping_id: @vehicle_shipping.id)
        get :get_order_details, params: {order_request_id:  vehicle_order.order_request_id}
      end
      it 'When user vehicle order is created' do
        expect(response.code).to eq('200')
      end 
    end
  end


  describe '#order cancelled get api' do
    let!(:account) { @account }
    let!(:selling) { @selling }
    let!(:order) { @vehicle_order }

    before do
      request.headers["token"] = login_user(account)
    end

    it 'order request cancelled' do
      get :order_cancelled, params: {order_request_id: @vehicle_order.order_request_id }
      expect(JSON.parse(response.code)).to eq(200)
    end

    it 'order request not found' do
      get :order_cancelled
      expect(JSON.parse(response.code)).to eq(404)
    end
  end


  describe "#upload_document" do
    let!(:account) { @account }
    let!(:selling) { @selling }
    let!(:order) { @vehicle_order }

    context "when the shipment ID and receipt are present" do
      it "attaches the receipt to the shipment" do
        put :upload_document, params: {data: { order_request_id: @vehicle_order.order_request_id, payment_receipt: fixture_file_upload(Rails.root.join('app/assets/images/test-image.png'), 'image/png'), passport: fixture_file_upload(Rails.root.join('app/assets/images/test-image.png'), 'image/png'),  }}
        message = JSON.parse(response.body)
        expect(message['status']).to eq 200
      end

      it "Shipment or receipt is missing" do
        put :upload_document, params: {data: { order_request_id: 0 }}
        message = JSON.parse(response.body)
        expect(message['status']).to eq 404
      end

      it "attaches the receipt to the shipment" do
        put :upload_document, params: {data: { order_request_id: @vehicle_order1.order_request_id, payment_receipt: fixture_file_upload(Rails.root.join('app/assets/images/test-image.png'), 'image/png'), passport: fixture_file_upload(Rails.root.join('app/assets/images/test-image.png'), 'image/png'),  }}
        message = JSON.parse(response.body)
        expect(message['status']).to eq 200
      end
    end
  end

  describe 'order_purhased' do 
    let!(:account) { @account }
    let!(:selling) { @selling }
    let!(:vehicle_order) {@vehicle_order}
    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_purchased, params: {status: "cancelled"}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["status"]).to eq(404)
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_purchased, params: {status: "in_transit"}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["status"]).to eq(404)
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_purchased, params: {status: "interested"}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["status"]).to eq(200)
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_purchased, params: {status: "delivered"}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["status"]).to eq(404)
      end 
    end

    context 'save' do
      before do
        request.headers["token"] = login_user(account)
        get :get_purchased, params: {status: "test"}
      end
      it 'When user vehicle order is created' do
        expect(JSON.parse(response.body)["error"]).to eq("Invalid Parameters")
      end 
    end
  end
end