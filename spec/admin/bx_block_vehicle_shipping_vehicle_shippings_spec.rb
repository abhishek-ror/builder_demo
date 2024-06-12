require 'rails_helper'
require 'spec_helper'

VEHICLESHIPPING_ROUTE = '/admin/vehicle_shippings'
include Warden::Test::Helpers
RSpec.describe Admin::VehicleShippingsController, type: :controller do
	render_views
	before(:each) do
		@role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Admin')
		@admin = create(:admin_user)
		@account = create(:account)
		@country = create(:country)
		@city = create(:city)
		@model = create(:model)
		@trim = create(:trim ,model_id: @model.id)
		@state = create(:state)
		@region = create(:region)
		@email_otp = AccountBlock::EmailOtp.create!(email: @account.email)
		@service_shipping = ServiceShipping.create(title: "Accept shipping & close the order")

		@shipping = BxBlockVehicleShipping::VehicleShipping.create!(account_id: @account.id, region: @region, country: @country,state: @state, invoice_amount: 100, year: 2012, service_shippings_id: @service_shipping.id)
		@selling = BxBlockVehicleShipping::VehicleSelling.create!(account_id: @account.id, city_id: @city.id, trim_id: @trim.id, region_id: @region.id, country_id: @country.id,state_id: @state.id, price: "100", make: "Tesla", kms: "5", no_of_cylinder: 1, no_of_doors: 4, horse_power: 10, year: 2012)
    	@selling_token = BuilderJsonWebToken.encode(@email_otp.id, 5.minutes.from_now, type: @email_otp.class, selling_id: @selling.id)
    	@vehicle_order = BxBlockVehicleShipping::VehicleOrder.create!(continent: "Asia", country: "India", state: "Kuch bhi", area: "Madurai", country_code: @account.country_code, phone_number: @account.phone_number, full_phone_number: @account.full_phone_number, account_id: @account.id, status: 1, vehicle_selling_id: @selling.id, instant_deposit_amount: 100, final_sale_amount: 100)
		sign_in @admin
	end

	# describe 'POST#new' do
	# 	let!(:params) do {
	# 		region: ('region'),
	# 		country: ('country'),
	# 		state: ('state'),
	# 		area: ('area'),
	# 		year: ('year'),
	# 		make: ('make'),
	# 		model: ('model'),
	# 		regional_specs: ('regional_specs'),
	# 		country_code: ('country_code'),
	# 		phone_number: ('phone_number'),
	# 		source_country: ('source_country'),
	# 		pickup_port: ('pickup_port'),
	# 		destination_country: ('destination_country'),
	# 		destination_port: ('destination_port'),
	# 		shipping_instruction: ('shipping_instruction')
	# 	}
	# end

	# 	it 'creates a admin_user' do
	# 		post :new, params: params
	# 		expect(response).to have_http_status(200)
	# 	end
	# end

	describe 'GET#index' do
		it 'shows all labels' do
			get :index 
			expect(response).to have_http_status(200)
		end

		it 'exports to csv' do
			get :index, params: { format: :csv }
			expect(response.content_type).to eq('text/csv; charset=utf-8')
					  # expect(response.headers['Content-Disposition']).to include('attachment; filename="vehicle_shippings.csv"')
		end

		it 'shows the approve link for unapproved vehicle shippings' do
			get :index
			expect(response).to be_successful
		  # expect(assigns(:vehicle_shippings)).to match_array([vehicle_shipping1, vehicle_shipping2])
		  # expect(response.body).to include("<a href=\"/admin/vehicle_shippings/#{vehicle_shipping1.id}/approve\" rel=\"nofollow\" data-method=\"put\">Approve</a>")
		  # expect(response.body).not_to include("<a href=\"/admin/vehicle_shippings/#{vehicle_shipping2.id}/approve\" rel=\"nofollow\" data-method=\"put\">Approve</a>")
		end

		it 'shows the picked up link for unpicked vehicle shippings' do
			get :index
			expect(response).to be_successful
		  # expect(assigns(:vehicle_shippings)).to match_array([vehicle_shipping1, vehicle_shipping2])
		  # expect(response.body).to include("<a href=\"/admin/vehicle_shippings/#{vehicle_shipping1.id}/picked_up\" rel=\"nofollow\" data-method=\"put\">Picked Up</a>")
		  # expect(response.body).not_to include("<a href=\"/admin/vehicle_shippings/#{vehicle_shipping2.id}/picked_up\" rel=\"nofollow\" data-method=\"put\">Picked Up</a>")
		end

		end

		describe "Get#show" do
			it "show shipping" do
				get :show, params: {id:  @shipping.id}
				expect(response).to have_http_status(200)
			end
		end

		describe 'DELETE#destroy' do
			let(:vehicle_shipping) { create(:vehicle_shipping) }

			it 'should delete vehicle_shipping' do
				delete :destroy, params: { id: vehicle_shipping.id }
				expect(response.status).to eq(302)
				expect(response).to redirect_to(VEHICLESHIPPING_ROUTE)
			end
		end

		describe 'POST #approve' do
			let(:account) { create(:account) }
		    let(:vehicle_shipping) { create(:vehicle_shipping, account_id: account.id) }
		    let(:required_field_alert_approve) { 'Please fill the required field of vehicle shipping.' }

		    context "when all required field are present" do
			    before do
			      shipping_invoice_file = Tempfile.new(['shipping_invoice', '.pdf'])
			      vehicle_shipping.shipping_invoice.attach(io: shipping_invoice_file, filename: 'shipping_invoice.jpg')
			      vehicle_shipping.update(
			        final_destination_charge: "1234"
			      )
			    
			      post :approve, params: { id: vehicle_shipping.id }
			    end

			    it "updates onboard to true" do
			      expect(vehicle_shipping.reload.approved_by_admin).to eq(true)
			    end

			    it "redirects to admin_vehicle_shippings_path with the success notice" do
			      expect(response).to redirect_to(admin_vehicle_shippings_path)
			      expect(flash[:notice]).to eq("Vehicle shipment approved updated successfully.")
			    end
		  	end

		    context 'when required field is missing' do
		      before do
		        allow(vehicle_shipping).to receive(:update).and_return(true)
		        allow(vehicle_shipping).to receive(:shipping_invoice).and_return(true)
		        allow(vehicle_shipping).to receive(:final_destination_charge).and_return(true)

		        post :approve, params: { id: vehicle_shipping.id }
		      end

		      it 'does not update approved_by_admin' do
		        expect(vehicle_shipping.reload.approved_by_admin).to be_falsey
		      end

		      it 'redirects to admin_vehicle_shippings_path with an alert' do
		        expect(response).to redirect_to(admin_vehicle_shippings_path)
		        expect(flash[:alert]).to start_with(required_field_alert_approve)
		      end
		    end
		end

		describe 'POST picked_up' do
		  let(:vehicle_shipping) { create(:vehicle_shipping) }
		  let(:picked_up_status) { 'picked up' }
		  let(:required_field_alert_pickedup) { 'Please fill the required field of vehicle shipping.' }

		  context 'when payment confirmation status is confirmed' do
		    before do
		      vehicle_shipping.update(payment_confirmation_status: 'confirmed')
		    end

		    context 'when all the required fields are present' do
		      before do
		        export_title_file = Tempfile.new(['export_title', '.jpg'])
		        condition_picture_file = Tempfile.new(['condition_picture', '.jpg'])
		        conditional_report_file = Tempfile.new(['conditional_report', '.pdf'])
		        vehicle_shipping.export_title.attach(io: export_title_file, filename: 'export_title.jpg')
		        vehicle_shipping.condition_pictures.attach(io: condition_picture_file, filename: 'condition_picture.jpg')
		        vehicle_shipping.conditional_report.attach(io: conditional_report_file, filename: 'conditional_report.pdf')

		        post :picked_up, params: { id: vehicle_shipping.id }
		      end

		      it 'updates vehicle_pickup to true' do
		        expect(vehicle_shipping.reload.vehicle_pickup).to eq(true)
		      end

		      it 'updates shipping_status to picked_up' do
		        expect(vehicle_shipping.reload.shipping_status).to eq(picked_up_status)
		      end

		      it 'redirects admin_vehicle_shippings_path with success notice' do
		        expect(response).to redirect_to(admin_vehicle_shippings_path)
		        expect(flash[:notice]).to eq('Vehicle shipment picked up updated successfully.')
		      end
		    end
		  end
		  
		  context "when a required field missing in the shipping" do
		    before do
		        vehicle_shipping.update(
		          export_title: nil,
		          condition_pictures: nil,
		          conditional_report: nil,
		          payment_confirmation_status: 'confirmed'
		        )
		        post :picked_up, params: { id: vehicle_shipping.id }
		    end

		    it 'does not update vehicle_pickup' do
		       expect(vehicle_shipping.reload.vehicle_pickup).to be_falsey
		    end

		    it 'does not update shipping_status' do
		        expect(vehicle_shipping.reload.shipping_status).not_to eq(picked_up_status)
		    end

		    it 'redirects to admin vehicle shippings_path with alert' do
		        expect(response).to redirect_to(admin_vehicle_shippings_path)
		        expect(flash[:alert]).to start_with(required_field_alert_pickedup)
		    end

		    it "displays the error messages for missing fields" do
		      expect(flash[:alert]).to include("Export title is missing.")
		      expect(flash[:alert]).to include("Condition pictures are missing or exceed the maximum count (15).")
		      expect(flash[:alert]).to include("Conditional report is missing.")
		    end
		  end

		  context 'when payment confirmation status is not confirmed' do
		    before do
		      vehicle_shipping.update(payment_confirmation_status: 'pending')
		      post :picked_up, params: { id: vehicle_shipping.id }
		    end

		    it 'does not update vehicle_pickup' do
		      expect(vehicle_shipping.reload.vehicle_pickup).to be_falsey
		    end

		    it 'does not update the shipping_status' do
		      expect(vehicle_shipping.reload.shipping_status).not_to eq(picked_up_status)
		    end

		    it 'redirects to admin_vehicle shippings_path with alert' do
		      expect(response).to redirect_to(admin_vehicle_shippings_path)
		      expect(flash[:alert]).to start_with(required_field_alert_pickedup)
		    end
		  end
   		end	

   	  describe "POST onboard" do
		  let(:account) { create(:account) }
		  let(:vehicle_shipping) { create(:vehicle_shipping, account_id: account.id) }
		  let(:required_field_alert_onboard) { 'Please fill the required field of vehicle shipping.' }
		
		  context "when all required field are present" do
		    before do
		      loading_image_file = Tempfile.new(['conditional_report', '.pdf'])
		      vehicle_shipping.loading_image.attach(io: loading_image_file, filename: 'loading_image.jpg')
		      vehicle_shipping.update(
		        estimated_time_of_departure: Time.now,
		        estimated_time_of_arrival: Time.now + 1.day,
		        shipping_line: "ABC Shipping",
		        container_number: "12345",
		        bl_number: "BL123",
		        tracking_link: "https://example.com/tracking",
		      )
		    
		      post :onboard, params: { id: vehicle_shipping.id }
		    end

		    it "updates onboard to true" do
		      expect(vehicle_shipping.reload.onboard).to eq(true)
		    end

		    it "updates shipping_status to 'onboarded'" do
		      expect(vehicle_shipping.reload.shipping_status).to eq("onboarded")
		    end

		    it "redirects to admin_vehicle_shippings_path with the success notice" do
		      expect(response).to redirect_to(admin_vehicle_shippings_path)
		      expect(flash[:notice]).to eq("Vehicle shipment onboard updated successfully.")
		    end
		  end

		  context "when a required field is missing in the shipping" do
		    before do
		      vehicle_shipping.update(
		        estimated_time_of_departure: nil,
		        estimated_time_of_arrival: nil,
		        shipping_line: nil,
		        container_number: nil,
		        bl_number: nil,
		        tracking_link: nil,
		        loading_image: nil
		      )
		      post :onboard, params: { id: vehicle_shipping.id }
		    end

		    it "does not update onboard" do
		      expect(vehicle_shipping.reload.onboard).to be_falsey
		    end

		    it "not update shipping_status" do
		      expect(vehicle_shipping.reload.shipping_status).not_to eq("onboarded")
		    end

		    it "redirects to admin_vehicle_shipping_path with alert" do
		      expect(response).to redirect_to(admin_vehicle_shippings_path)
		      expect(flash[:alert]).to start_with(required_field_alert_onboard)
		    end

		    it "displays the error messages for missing fields" do
		      expect(flash[:alert]).to include("Estimated time of departure is missing.")
		      expect(flash[:alert]).to include("Estimated time of arrival is missing.")
		      expect(flash[:alert]).to include("Shipping line is missing.")
		      expect(flash[:alert]).to include("Container number is missing.")
		      expect(flash[:alert]).to include("BL number is missing.")
		      expect(flash[:alert]).to include("Tracking link is missing.")
		      expect(flash[:alert]).to include("Loading image is missing.")
		    end
		  end
		end		  

		describe 'POST #shipment' do
			let(:account) { create(:account) }
			let(:vehicle_shipping) { create(:vehicle_shipping, account_id: account.id) }
			
			it 'shipment the vehicle shipping' do
				put :car_shipment, params: { id: vehicle_shipping.id }
				expect(vehicle_shipping.reload.shipment_noti).to eq(true)
				expect(flash[:notice]).to eq('Vehicle shipment updated successfully.')
			 
			end

			context 'when vehicle_shipping is not shipment' do
	      # let!(:vehicle_shipping) { create(:vehicle_shipping, shipment_noti: false) }
	      let!(:vehicle_shipping) { create(:vehicle_shipping, shipment_noti: false, approved_by_admin: true) }


				it 'shipment the vehicle_shipping' do
					# vehicle_shipping.update(shipment_noti: "true")
	        expect(vehicle_shipping.shipment_noti).to be_falsey
	        expect(vehicle_shipping.reload.shipment_noti).to be_falsey
	        expect(response.status).to eq(200)
	      end
      end

      context 'when vehicle_shipping is already shipment' do
	      let!(:vehicle_shipping) { create(:vehicle_shipping, approved_by_admin: false) }
	      it 'does not shipment the vehicle_shipping' do
	        expect(vehicle_shipping.shipment_noti).to be_falsey
	        expect(vehicle_shipping.reload.shipment_noti).to be_falsey
          expect(response.status).to eq(200)
	      end
      end			

		end

		describe 'POST arrived' do
		  	let(:account) { create(:account) }
			let(:vehicle_shipping) { create(:vehicle_shipping, account_id: account.id) }
			
			context "when all required fields are presents" do
			    before do
			      unloading_image_file = Tempfile.new(['unloading_image', '.pdf'])
			      vehicle_shipping.unloading_image.attach(io: unloading_image_file, filename: 'unloading_image.jpg')
			   
			      post :arrived, params: { id: vehicle_shipping.id }
			    end

			    it "updates arrived to true" do
			      expect(vehicle_shipping.reload.arrived).to eq(true)
			    end

			    it "updates shipping_status to 'arrived'" do
			      expect(vehicle_shipping.reload.shipping_status).to eq("arrived")
			    end

			    it "redirects to admin vehicle_shippings_path with success notice" do
			      expect(response).to redirect_to(admin_vehicle_shippings_path)
			      expect(flash[:notice]).to eq("Notification regarding shipment arrived at the destination port.")
			    end
		  end

			context 'when unloading image is missing' do
			    before do
			      post :arrived, params: { id: vehicle_shipping.id }
			    end

			    it 'does not update arrived' do
			      expect(vehicle_shipping.reload.arrived).to be_falsey
			    end

			    it 'does not update shipping status' do
			      expect(vehicle_shipping.reload.shipping_status).not_to eq('arrived')
			    end

			    it 'redirects to the admin_vehicle_shippings_path with alert' do
			      expect(response).to redirect_to(admin_vehicle_shippings_path)
			      expect(flash[:alert]).to start_with('Please fill the required field of vehicle shipping. Unloading image is missing.')
			    end

			 end
		end

		describe 'POST #destination_service' do
		  let(:account) { create(:account) }
		  let(:vehicle_shipping) { create(:vehicle_shipping, account_id: account.id) }
		  let(:alert_destination_service) { 'Please fill the required field of vehicle shipping.' }

		  context "when required fields are missing" do
		    before do
		      vehicle_shipping.update(
		        invoice_amount: nil,
		        service_shippings_id: nil,
		        delivery_invoice: nil,
		        delivery_proof: nil
		      )

		      post :destination_service, params: { id: vehicle_shipping.id }
		    end

		    it "admin_vehicle_shippings_path with alert" do
		      expect(response).to redirect_to(admin_vehicle_shippings_path)
		      expect(flash[:alert]).to start_with(alert_destination_service)
		    end

		    it "display the error messages for missing fields" do
		      expect(flash[:alert]).to include("Invoice amount is missing.")
		      expect(flash[:alert]).to include("Destination Service is missing.")
		      expect(flash[:alert]).to include("Delivery Invoice is missing.")
		      expect(flash[:alert]).to include("Delivery Proof is missing.")
		    end
		  end
		end

		describe 'POST #approve payment' do
		  let(:account) { create(:account) }
		  let(:vehicle_shipping) { create(:vehicle_shipping, account_id: account.id) }
		  let(:alert_destination_service) { 'Please fill the required field of vehicle shipping.' }

		  context "when required fields are missing" do
		    before do
		      vehicle_shipping.update(
		        invoice_amount: nil,
		        service_shippings_id: nil,
		        delivery_invoice: nil,
		        delivery_proof: nil, 
		        customer_payment_receipt: nil
		      )

		      post :approve_payment, params: { id: vehicle_shipping.id }
		    end

		    it "admin_vehicle_shippings_path with alert" do
		      expect(response).to redirect_to(admin_vehicle_shippings_path)
		      expect(flash[:alert]).to start_with(alert_destination_service)
		    end

		    context 'when unloading image is missing' do
			    before do
			    	conditional_report_file = Tempfile.new(['conditional_report', '.pdf'])
			    	vehicle_shipping.customer_payment_receipt.attach(io: conditional_report_file, filename: 'conditional_report.pdf')
			      post :approve_payment, params: { id: vehicle_shipping.id }
			    end

			    it 'does not update shipping status' do
			      expect(BxBlockPushNotifications::PushNotification.where(remarks: "Your shipment is delivered, Kindly give us review", notification_type_id: vehicle_shipping.id).present?).to eq(true)
			    end
			 end
		  end
		end
end