require 'rails_helper'
require 'spec_helper'

VEHICLESHIPPING_ROUTE = '/admin/vehicle_shippings'
include Warden::Test::Helpers
RSpec.describe Admin::VehicleOrdersController, type: :controller do
	render_views
	before(:each) do
		@account = create(:account)
		@admin = create(:admin_user)
    @country = create(:country)
    @city = create(:city)
    @model = create(:model)
    @trim = create(:trim ,model_id: @model.id)
    @state = create(:state)
    @region = create(:region)
    @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)               
    @email_otp = AccountBlock::EmailOtp.create!(email: @account.email)
    @selling = BxBlockVehicleShipping::VehicleSelling.create!(account_id: @account.id, city_id: @city.id, trim_id: @trim.id, region_id: @region.id, country_id: @country.id,state_id: @state.id, price: "100", make: "Tesla", kms: "5", no_of_cylinder: 1, no_of_doors: 4, horse_power: 10, year: 2012)
    @selling_token = BuilderJsonWebToken.encode(@email_otp.id, 5.minutes.from_now, type: @email_otp.class, selling_id: @selling.id)
    @vehicle_order = BxBlockVehicleShipping::VehicleOrder.create!(continent: "Asia", country: "India", state: "Kuch bhi", area: "Madurai", country_code: @account.country_code, phone_number: @account.phone_number, full_phone_number: @account.full_phone_number, account_id: @account.id, status: 1, vehicle_selling_id: @selling.id, instant_deposit_amount: 100, final_sale_amount: 100)
    sign_in @admin
	end

	describe "PUT #update" do
	    context "with valid parameters" do
	      it "updates the vehicle order and redirects to the show page" do
	        put :update, params: { id: @vehicle_order.id, bx_block_vehicle_shipping_vehicle_order: { instant_deposit_amount: 100, final_sale_amount: 200 } }
	        expect(response).to redirect_to(admin_vehicle_order_path(@vehicle_order))
	        expect(flash[:error]).to be_nil
	      end
	    end

	    context "with missing final_sale_amount" do
	      it "displays an error flash message and redirects back to the edit page" do
	        put :update, params: { id: @vehicle_order.id, bx_block_vehicle_shipping_vehicle_order: { instant_deposit_amount: 100, final_sale_amount: nil } }
	        expect(response).to redirect_to(edit_admin_vehicle_order_path(@vehicle_order, 'bx_block_vehicle_shipping_vehicle_order[instant_deposit_amount]' => 100))
	        expect(flash[:error]).to eq("Please update the final sale amount when updating the instant deposit amount.")
	      end
	    end

	    context "with missing instant_deposit_amount" do
	      it "displays an error flash message and redirects back to the edit page" do
	        put :update, params: { id: @vehicle_order.id, bx_block_vehicle_shipping_vehicle_order: { instant_deposit_amount: nil, final_sale_amount: 200 } }
	        expect(response).to redirect_to(edit_admin_vehicle_order_path(@vehicle_order, 'bx_block_vehicle_shipping_vehicle_order[final_sale_amount]' => 200))
	        expect(flash[:error]).to eq("Please update the instant deposit amount when updating the final sale amount.")
	      end
	    end
	end



	# describe 'POST#new' do
	# 	let!(:params) do {
	# 		continent:('continent'),
	# 		country:('country'),
	# 		state:('state'),
	# 		area:('area'),
	# 		country_code:('country_code'),
	# 		phone_number:('phone_number'),
	# 		full_phone_number:('full_phone_number'),
	# 		status:('status'),
	# 		instant_deposit_amount:('instant_deposit_amount'),
	# 		instant_deposit_status:('instant_deposit_status'),
	# 		final_sale_amount:('final_sale_amount'),
	# 		final_invoice_payment_status:('final_invoice_payment_status'),
	# 		final_invoice:('final_invoice'),
	# 		payment_receipt:('payment_receipt'),
	# 		passport:('passport'),
	# 		other_documents:('other_documents')
	# 	}
	# 	end
	# 	it 'creates a admin_user' do
	# 		post :new, params: params
	# 		expect(response).to have_http_status(200)
	# 	end
	# end

	describe 'POST#edit' do
        let!(:params) do {
          final_sale_amount: "10,000"
        } 
        end

        it 'edit a account' do
          put :edit, params: { id: @vehicle_order.id, vehicle_orders: params }
          expect(response).to have_http_status(200)
        end 
    end


	describe 'GET#index' do
		
		describe "Get#show" do
			it "show shipping" do
				get :show, params: {id:  @vehicle_order.id}
				expect(response).to have_http_status(200)
			end
		end
	end
end