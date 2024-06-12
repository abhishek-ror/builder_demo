require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::VehicleInspectionsController, type: :controller do

    render_views

    before(:each) do
        @admin = create(:admin_user)
        @vehicle_inspection = create(:vehicle_inspection)
        sign_in @admin
    end

    describe "PUT #update" do
      context "with valid parameters" do
        it "updates the vehicle inspection and redirects to the show page" do
          put :update, params: { id: @vehicle_inspection.id, vehicle_inspection: { instant_deposit_amount: 100, final_sale_amount: 200 } }
          expect(response).to redirect_to(admin_vehicle_inspection_path(@vehicle_inspection))
          expect(flash[:error]).to be_nil
        end
      end

      context "with missing final_sale_amount" do
        it "displays an error flash message and redirects back to the edit page" do
          put :update, params: { id: @vehicle_inspection.id, vehicle_inspection: { instant_deposit_amount: 100, final_sale_amount: nil } }
          expect(response).to redirect_to(edit_admin_vehicle_inspection_path(@vehicle_inspection, 'vehicle_inspection[instant_deposit_amount]' => 100))
          expect(flash[:error]).to eq("Please update the final sale amount when updating the instant deposit amount.")
        end
      end

      context "with missing instant_deposit_amount" do
        it "displays an error flash message and redirects back to the edit page" do
          put :update, params: { id: @vehicle_inspection.id, vehicle_inspection: { instant_deposit_amount: nil, final_sale_amount: 200 } }
          expect(response).to redirect_to(edit_admin_vehicle_inspection_path(@vehicle_inspection, 'vehicle_inspection[final_sale_amount]' => 200))
          expect(flash[:error]).to eq("Please update the instant deposit amount when updating the final sale amount.")
        end
      end
    end

    describe 'POST#new' do
        let!(:account) { create(:account) }
        let!(:company) { create(:company) }
        let!(:model) { create(:model, company: company) }
        let!(:regional_spec) {create(:regional_spec_data)}
        let!(:city) {create(:city)}

        it 'creates a vehicle_inspection' do
           post :new, params: { vehicle_inspection: { 
                        account_id: account.id, model_id: model.id, city_id: city.id, make_year: 1998, price: 30000, seller_mobile_number: "7974578489", seller_country_code: "+91", advertisement_url: "https://www.car24.com/", seller_email: "user1@gmail.com", notes_for_the_inspector: "this car is the best for user", inspection_amount: 670, seller_name: "usertest", instant_deposit_amount: 100, final_sale_amount: 150,regional_spec: regional_spec.id
            } }
          expect(response).to have_http_status(200)
        end 
    end
   
    describe 'GET#index' do
        it 'shows all labels' do
          get :index 
          expect(response).to have_http_status(200)
        end 
    end

    describe "Get#show" do
    it "show vehicle_inspection" do
      get :show, params: {id:  @vehicle_inspection.id}
      expect(response).to have_http_status(200)
    end
  end
end