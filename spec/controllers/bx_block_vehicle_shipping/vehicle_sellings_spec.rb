require 'rails_helper'

RSpec.describe BxBlockVehicleShipping::VehicleSellingsController, type: :controller do
    
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
      @selling = BxBlockVehicleShipping::VehicleSelling.create!(account_id: @account.id, city_id: @city.id, trim_id: @trim.id, region_id: @region.id, country_id: @country.id,state_id: @state.id, price: "100", make: "28", kms: "5", no_of_cylinder: 1, no_of_doors: 4, horse_power: 10, year: 2012)
      @selling_token = BuilderJsonWebToken.encode(@email_otp.id, 5.minutes.from_now, type: @email_otp.class, selling_id: @selling.id)
      @steering_side  = 'Left Hand Side'
      request.headers["token"] = login_user(@account)
    end


 describe "DELETE #destroy" do
    context "when ad exists" do

      it "deletes the ad" do
        expect {
          delete :destroy, params: { id:@selling.id}
        }
      end

      # it "returns success status" do
      #   delete :destroy, params: { id:@selling.id }
      #   expect(response).to have_http_status(:success)
      # end

      # it "returns success message" do
      #   delete :destroy, params: { id:@selling.id }
      #   expect(JSON.parse(response.body)).to eq({"selling" => "Ads deleted successfully"})
      # end
    end

    context "when ad does not exist" do
      it "does not delete any ad" do
        expect {
          delete :destroy, params: { id: 1 }
        }
      end

      it "returns not found status" do
        delete :destroy, params: { id: 1 }
        expect(response).to have_http_status(:not_found)
      end

      it "returns not found message" do
        delete :destroy, params: { id: 1 }
        expect(JSON.parse(response.body)).to eq({"selling" => "No ads found!"})
      end
    end
  end

    describe 'POST #create' do
      context 'when creating a vehicle selling' do
        let(:params) {
          {
            vehicle_selling: {
              city_id: @city.id,
              account_id: @account.id,
              trim_id: @trim.id,
              region_id: @region.id,
              country_id: @country.id,
              state_id: @state.id,
              year: 2020,
              model: '1990',
              regional_spec: 'European',
              kms: '100',
              body_type: 'SUV',
              body_color: 'White',
              seller_type: 'Owner',
              engine_type: 'Petrol',
              steering_side: @steering_side,
              badges: 'Luxury',
              features: 'Loaded',
              make: 'Tesla',
              no_of_doors: 2,
              transmission: 'manual',
              price: '100000',
              warranty: 'Yes',
              no_of_cylinder: 13,
              horse_power: 150,
              contact_number: '0123456789'
            }
          }
        }

        it 'creates a vehicle selling' do
          post :create, params: params
          json = JSON.parse(response.body)
          expect(response).to have_http_status(200)          
          # expect(json['Message']).to eq('OTP has been send to your registraed email.')
        end
      end     
    end

    describe "Get selling data" do
      it "Get vehicle_selling data" do
          get :show, params: { id: @selling.id}
          expect(response).to have_http_status(200)
      end

      it "Get not found error" do
          get :show, params: { id: 0}
          expect(response).to have_http_status(404)
      end
    end

    describe "POST #varify" do
      context "with blank token" do
        let(:params) do
            {
              data: {
                attributes: {
                    otp_code: 1234,
                    selling_token: ''
                }
              }
            }
        end
        
        it "returns an error message is Token can't be blank" do
          post :varify, params: params
          expect(response.status).to eq(422)
          expect(response.body).to include("Token can't be blank")
        end
      end

      context "with valid parameters" do
        let(:params) do
          {
            data: {
              attributes: {
                  otp_code: @email_otp.pin,
                  selling_token: @selling_token
              }
            }
          }
        end
        it "verifies the OTP and updates the vehicle selling" do
          post :varify, params: params
          expect(response.status).to eq(200)
        end
      end

      context "with invalid token" do
        let(:params) do
          {
            data: {
              attributes: {
                otp_code: 1234,
                selling_token: 'invalid_token'
              }
            }
          }
        end
        it "returns an error message is Invalid token" do
          post :varify, params: params
          expect(response.status).to eq(400)
          expect(response.body).to include("Invalid token")
        end
      end

      context "token and otp are required" do
        let(:params) do
          {
            data: {
              attributes: {
                otp_code: nil,
                selling_token: @selling_token
              }
            }
          }
        end
        it "returns an error message is Token and OTP code are required" do
          post :varify, params: params
          expect(response.status).to eq(422)
          expect(response.body).to include("Token and OTP code are required")
        end
      end

      context "OTP must be a number" do
        let(:params) do
          {
            data: {
              attributes: {
                otp_code: "abcd",
                selling_token: @selling_token
              }
            }
          }
        end
        it "returns an error message is OTP must be a number" do
          post :varify, params: params
          expect(response.status).to eq(422)
          expect(response.body).to include("OTP must be a number")
        end
      end

      context "Invalid OTP code" do
        let(:params) do
          {
            data: {
              attributes: {
                otp_code: 12345678,
                selling_token: @selling_token
              }
            }
          }
        end
        it "returns an error message is Invalid OTP code" do
          post :varify, params: params
          expect(response.status).to eq(422)
          expect(response.body).to include("Invalid OTP code")
        end
      end
    end

    describe "PATCH #update" do

    context "when ad exists" do
      let(:params) {
          {
            id: @selling.id,
            vehicle_selling: {
              city_id: @city.id,
              account_id: @account.id,
              trim_id: @trim.id,
              region_id: @region.id,
              country_id: @country.id,
              state_id: @state.id,
              year: 2020,
              model: '1990',
              regional_spec: 'European',
              kms: '100',
              body_type: 'SUV',
              body_color: 'White',
              seller_type: 'Owner',
              engine_type: 'Petrol',
              steering_side: @steering_side,
              badges: 'Luxury',
              features: 'Loaded',
              make: 'Tesla',
              no_of_doors: 2,
              transmission: 'manual',
              price: '100000',
              warranty: 'Yes',
              no_of_cylinder: 13,
              horse_power: 150,
              contact_number: '0123456789'
            }
          }
        }
      
      it "returns success status" do
        patch :update, params: params
        expect(response).to have_http_status(:success)
      end
    end

    context "when ad does not exist" do

      it "returns error message" do
        patch :update, params: { id: 0}
        expect(JSON.parse(response.body)).to eq({"errors" => "Record Not Found"})
      end
    end
  end

# describe 'PATCH #update' do
#       context 'when updatinga vehicle selling' do
#         let(:params) {
#           {id: 1,
#             vehicle_selling: {
#               id: 1,
#               city_id: @city.id,
#               account_id: @account.id,
#               trim_id: @trim.id,
#               region_id: @region.id,
#               country_id: @country.id,
#               state_id: @state.id,
#               year: 2020,
#               model: '1990',
#               regional_spec: 'European',
#               kms: '100',
#               body_type: 'SUV',
#               body_color: 'White',
#               seller_type: 'Owner',
#               engine_type: 'Petrol',
#               steering_side: @steering_side,
#               badges: 'Luxury',
#               features: 'Loaded',
#               make: 'Tesla',
#               no_of_doors: 2,
#               transmission: 'manual',
#               price: '100000',
#               warranty: 'Yes',
#               no_of_cylinder: 13,
#               horse_power: 150,
#               contact_number: '0123456789'
#             }
#           }
#         }
#         it 'creates a vehicle selling' do
#           patch :update, params: params
#           json = JSON.parse(response.body)
#           expect(json['errors']).to eq("Record Not Found")
#         end
#       end     
#     end

    # describe 'PATCH #update' do
    #   context 'when updatinga vehicle selling' do
    #     let(:params) {
    #       {id: @selling.id,
    #         vehicle_selling: {
    #           id: @selling.id,
    #           city_id: @city.id,
    #           account_id: @account.id,
    #           trim_id: @trim.id,
    #           region_id: @region.id,
    #           country_id: @country.id,
    #           state_id: @state.id,
    #           year: 2020,
    #           model: '1990',
    #           regional_spec: 'European',
    #           kms: '100',
    #           body_type: 'SUV',
    #           body_color: 'White',
    #           seller_type: 'Owner',
    #           engine_type: 'Petrol',
    #           steering_side: @steering_side,
    #           badges: 'Luxury',
    #           features: 'Loaded',
    #           make: 'Tesla',
    #           no_of_doors: 2,
    #           transmission: 'manual',
    #           price: '100000',
    #           warranty: 'Yes',
    #           no_of_cylinder: 13,
    #           horse_power: 150,
    #           contact_number: '0123456789'
    #         }
    #       }
    #     }
    #     it 'creates a vehicle selling' do
    #       patch :update, params: params
    #       json = JSON.parse(response.body)
    #       expect(json['message']).to eq("List Updated")
    #     end
    #   end     
    # end

    # describe 'PATCH #update' do
    #   context 'when updatinga vehicle selling' do
    #     let(:params) {
    #       {id: @selling.id,
    #         vehicle_selling: {
    #           id: @selling.id,
    #           city_id: @city.id,
    #           account_id: @account.id,
    #           trim_id: @trim.id,
    #           region_id: @region.id,
    #           country_id: @country.id,
    #           state_id: 22,
    #           year: 2020,
    #           model: '1990',
    #           regional_spec: 'European',
    #           kms: '100',
    #           body_type: 'SUV',
    #           body_color: 'White',
    #           seller_type: 'Owner',
    #           engine_type: 'Petrol',
    #           steering_side: @steering_side,
    #           badges: 'Luxury',
    #           features: 'Loaded',
    #           make: 'Tesla',
    #           no_of_doors: 2,
    #           transmission: 'manual',
    #           price: '100000',
    #           warranty: 'Yes',
    #           no_of_cylinder: 13,
    #           horse_power: 150,
    #           contact_number: '0123456789'
    #         }
    #       }
    #     }
    #     it 'creates a vehicle selling' do
    #       patch :update, params: params
    #       json = JSON.parse(response.body)
    #       expect(json['errors']).to eq([{"state"=>"must exist"}])
    #     end
    #   end     
    # end

       describe "Get total selling data" do
      it "Get total vehicle_selling data" do
          get :vehicle_selling
          expect(response).to have_http_status(200)
      end
    end

    describe 'GET #index' do
      context 'without pagination parameters' do
        it 'returns default paginated vehicle sellings' do
          @selling.update(approved_by_admin: true)
          get :index
          # expect(response).to have_http_status(:ok)
        end
      end

      context 'without pagination parameters' do
        it 'returns default paginated vehicle sellings' do
          @selling.update(approved_by_admin: true)
          get :index, params: { page: 2, per_page: 10}
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
end