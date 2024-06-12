require 'rails_helper'
RSpec.describe BxBlockVehicleShipping::VehiclePaymentsController, type: :controller do
  before do
      @account = create(:account)
      @country = create(:country)
      @city = create(:city)
      @model = create(:model)
      @trim = create(:trim ,model_id: @model.id)
      @state = create(:state)
      @region = create(:region)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
      @email_otp = AccountBlock::EmailOtp.create!(email: @account.email)
      @vehicle_selling = BxBlockVehicleShipping::VehicleSelling.create!(account_id: @account.id, city_id: @city.id, trim_id: @trim.id, region_id: @region.id, country_id: @country.id,state_id: @state.id, price: 90000, make: "Tesla", kms: "5", no_of_cylinder: 1, no_of_doors: 4, horse_power: 10, year: 2012)
      @vehicle_order = BxBlockVehicleShipping::VehicleOrder.create!(continent: "Asia", country: "India", state: "Kuch bhi", area: "Madurai", country_code: @account.country_code, phone_number: @account.phone_number, full_phone_number: @account.full_phone_number, account_id: @account.id, status: 1, vehicle_selling_id: @vehicle_selling.id, instant_deposit_amount: 100, final_sale_amount: 100)
      request.headers["token"] = login_user(@account)
  end

  describe "POST #payment" do
    let(:payment_attributes) {
      {
       amount: @vehicle_order.instant_deposit_amount,
       currency: 'usd',
       description: 'VehicleSelling-Price',
       metadata: {type: 'BxBlockVehicleShipping::VehicleOrder', id: @vehicle_order.id},
      }
    }

    context "with valid params" do
      before do
        allow_any_instance_of(BxBlockPayments::CreditCardService).to receive(:create_credit_card).and_return("card_123")
        allow_any_instance_of(BxBlockPayments::StripeIntegrationService).to receive(:stripe_payment_intent).and_return(double(id: "payment_123", amount: 100))
      
      end

      it "creates a new payment" do
        post :payment, params: { order_request_id: @vehicle_order.order_request_id, card: { number: "4242424242424242", month: "12", year: "2023", cvc: "123" } }
        # expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["message"]).to eq("payment process successful")
        expect(response.status).to eq(200)    
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post :payment, params: {  order_request_id: @vehicle_order.order_request_id, card: { number: "4242424242424242", month: "12", year: "2020", cvc: "123" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Unable to initiate payment process")
      end
    end

    # context "without vehicle_id" do
    #   it "returns an error response" do
    #     post :payment, params: { card: { number: "4242424242424242", month: "12", year: "2020", cvc: "123" } }
    #     expect(response.status).to eq(500)
    #   end
    # end

    # context "without card" do
    #   it "returns an error response" do
    #     post :payment, params: { vehicle_id: @vehicle_selling.id }
    #     debugger
    #     # expect(response.status).to eq(400)
    #     expect(response).to have_http_status(:bad_request)
    #   end
    # end
  end
end

