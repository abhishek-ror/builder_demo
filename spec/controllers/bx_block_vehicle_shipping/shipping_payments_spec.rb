require 'rails_helper'
RSpec.describe BxBlockVehicleShipping::ShippingPaymentsController, type: :controller do
  before do
    @account = create(:account)
    @country = create(:country)
    @city = create(:city)
    @model = create(:model)
    @trim = create(:trim, model_id: @model.id)
    @state = create(:state)
    @region = create(:region)
    @token = BuilderJsonWebToken.encode(@account.id, { account_type: @account.type }, 1.year.from_now)
    @email_otp = AccountBlock::EmailOtp.create!(email: @account.email)
    @vehicle_order = BxBlockVehicleShipping::VehicleShipping.create!(final_destination_charge: '1000',
                                                                     account_id: @account.id, approved_by_admin: true, invoice_amount: 100, year: 2012)
    request.headers['token'] = login_user(@account)
  end

  describe 'POST #payment' do
    let(:payment_attributes) do
      {
        amount: @vehicle_order.final_destination_charge,
        currency: 'usd',
        description: 'VehicleSelling-Price',
        metadata: { type: 'BxBlockVehicleShipping::VehicleOrder', id: @vehicle_order.id }
      }
    end

context 'with valid params' do
  before do
    allow_any_instance_of(BxBlockPayments::CreditCardService).to receive(:create_credit_card).and_return('card_123')
    allow_any_instance_of(BxBlockPayments::StripeIntegrationService).to receive(:stripe_payment_intent).and_return(double(
                                                                                                                     id: 'payment_123', amount: 100
                                                                                                                   ))
  end

  it 'creates a new payment' do
    post :payment,
         params: { order_request_id: @vehicle_order.id, shipment_id: @vehicle_order.id,
                   card: { number: '4242424242424242', month: '12', year: '2023', cvc: '123' } }
    message = JSON.parse(response.body)
    expect(message['message']).to eq 'payment process successful'
    expect(message['success']).to eq true
  end

  it 'Unable to initiate payment process due to the invalid shipment id/Not Approved by admin yet' do
    post :payment,
         params: { order_request_id: @vehicle_order.id, shipment_id: 0,
                   card: { number: '4242424242424242', year: '2023', cvc: '123' } }
    message = JSON.parse(response.body)
    expect(message['message']).to eq 'Unable to initiate payment process due to the invalid shipment id/Not Approved by admin yet'
    expect(message['success']).to eq false
  end
end
  end
end

