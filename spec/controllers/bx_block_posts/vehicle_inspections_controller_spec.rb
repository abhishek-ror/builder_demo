require 'rails_helper'

RSpec.describe ::BxBlockPosts::VehicleInspectionsController, type: :controller do
  let(:expected_response_keys) do
    %w[model_id city_id make_year about price seller_country_code seller_mobile_number seller_email seller_name
       inspection_amount notes_for_the_inspector status inspection_report advertisement_url city regional_spec order_details model make images car_order car_data auto_images]
  end
  let(:small_keys) do
    %w[id type attributes]
  end
  let(:status_keys) do
    %w[success message]
  end
  let(:expected_data) do
    'this is the best car for user'
  end
  describe 'All APIS' do
    let!(:account) { create(:account) }
    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) do
      create(:bx_block_plan_user_subscription, plan: plan, account: account)
    end
    let!(:company) { create(:company) }
    let!(:model) { create(:model, company: company) }
    let!(:trim) { create(:trim, model: model) }
    let!(:region) { create(:region) }
    let!(:country) { create(:country, region: region) }
    let!(:state) { create(:state, country: country) }
    let!(:city) { create(:city, state: state) }
    let!(:regional_spec) { create(:regional_spec_data) }
    let!(:inspection_charge) { create(:inspection_charge) }
    let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
    let!(:vehicle_inspection1) { create(:vehicle_inspection, account: account, city: city, model: model) }
    let!(:vehicle_inspection) do
      create(:vehicle_inspection, account: account, city: city, model: model, car_ad: car_ad1, status: 5, status_updated_at: Time.now)
    end
    let!(:inspection_report) { create(:inspection_report, vehicle_inspection: vehicle_inspection) }

    context 'index' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        get :index, params: { status: 'inprogress' }
        expect(JSON.parse(response.body).keys).to eq(['data'])
        expect(JSON.parse(response.code)).to eq(200)
      end
    end

    context 'show_inspection' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        get :show_inspection, params: { id: vehicle_inspection.id }
        expect(JSON.parse(response.body).keys).to eq(['data'])
        expect(JSON.parse(response.code)).to eq(200)
      end
    end

    context 'show_inspection wothout car ad' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        get :show_inspection, params: { id: vehicle_inspection1.id }
        expect(JSON.parse(response.body).keys).to eq(['data'])
        expect(JSON.parse(response.code)).to eq(200)
      end
    end

    context 'my_inspections' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        get :my_inspections, params: { status: 'rejected' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'destroy' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        delete :destroy, params: { id: vehicle_inspection.id }
        expect(JSON.parse(response.body).keys).to eq(['success'])
        expect(JSON.parse(response.body)['success']).to eq(true)
      end

      it 'invalid id' do
        delete :destroy, params: { id: 245 }
        expect(JSON.parse(response.body).keys).to eq(['message'])
        expect(JSON.parse(response.body)['message']).to eq("Car Vehicle Inspection with id 245 doesn't exists")
      end
    end

    context 'show' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        get :show, params: {  id: vehicle_inspection.id }
        expect(JSON.parse(response.body)['data'].keys).to eq(small_keys)
        expect(JSON.parse(response.body)['data']['type']).to eq('vehicle_inspection')
      end
    end

    # context 'show_notification' do
    #   before do
    #     request.headers['token'] = login_user(account)
    #   end
    #   it 'data not present' do
    #     get :show_notification
    #     expect(JSON.parse(response.body).keys).to eq(['message'])
    #     expect(JSON.parse(response.body)['message']).to eq('Push Notification Not Found')
    #   end
    # end

    context 'update' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        put :update, params: { id: vehicle_inspection.id, vehicle_inspection: { about: expected_data } }
        expect(JSON.parse(response.body)['data'].keys).to eq(small_keys)
        expect(JSON.parse(response.body)['data']['type']).to eq('vehicle_inspection')
        expect(JSON.parse(response.body)['data']['attributes']['about']).to eq(expected_data)
      end

      it 'invaid id present' do
        put :update,
            params: { id: vehicle_inspection.id,
                      vehicle_inspection: { seller_name: nil, about: 'this is the best car for user', price: '' } }
        expect(JSON.parse(response.body)['data'].keys).to eq(small_keys)
        # expect(JSON.parse(response.body)['data']['type']).to eq('error')
      end
    end

    context 'get_inspection_amount' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        get :get_inspection_amount, params: {  country: country.name }
        expect(JSON.parse(response.body).keys).to eq(%w[amount success])
        expect(JSON.parse(response.body)['success']).to eq(true)
      end
    end

    context 'payment' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        post :payment,
             params: { id: vehicle_inspection1.id,
                       card: { number: 5_555_555_555_554_444, month: 7, year: 2030, cvc: 898 } }
        expect(JSON.parse(response.body).keys).to eq(%w[success url payment_id payment_message
                                                        message])
        expect(JSON.parse(response.body)['success']).to eq(true)
      end
    end

    context 'payment' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'invalid data present' do
        post :payment,
             params: { id: vehicle_inspection1.id,
                       card: { number: 5_555_555_555_550_000, month: 7, year: 2030, cvc: 898 } }
        expect(JSON.parse(response.body).keys).to eq(%w[success message])
        expect(JSON.parse(response.body)['success']).to eq(false)
      end
    end

    context 'update_acceptance_status' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        post :update_acceptance_status, params: { id: vehicle_inspection1.id, status: 'buy' }
        expect(JSON.parse(response.body)['data'].keys).to eq(small_keys)
        expect(JSON.parse(response.body)['data']['type']).to eq('vehicle_inspection')
      end
    end

    context 'inspection_report' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        post :inspection_report, params: { id: vehicle_inspection.id }
        expect(JSON.parse(response.body)['data']['data'].keys).to eq(small_keys)
        expect(JSON.parse(response.body)['data']['data']['type']).to eq('vehicle_inspection_report')
        expect(JSON.parse(response.body)['status']).to eq(200)
      end

      it 'invalid data present' do
        post :inspection_report, params: { id: vehicle_inspection1.id }
        expect(JSON.parse(response.body)['status']).to eq(200)
      end
    end

    context 'payment_status' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'invalid data present' do
        post :payment_status, params: { id: vehicle_inspection.id }
        expect(JSON.parse(response.body)['status']).to eq(422)
      end
    end

    context 'create' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        post :create, params: { vehicle_inspection: {
          model_id: model.id, city_id: city.id, make_year: 1998, price: 30_000, seller_mobile_number: '7974578489', seller_country_code: '+91', advertisement_url: 'https://www.car24.com/', seller_email: 'user1@gmail.com', notes_for_the_inspector: 'this car is the best for user', inspection_amount: 670, seller_name: 'usertest', instant_deposit_amount: 100, final_sale_amount: 150, regional_spec: regional_spec.id
        },  card: { number: 5_555_555_555_554_444, month: 7, year: 2030, cvc: 898 }}
        # expect(JSON.parse(response.body)['data'].keys).to eq(small_keys)
        expect(JSON.parse(response.body)["success"]).to eq(true)
      end

      it 'invalid card data present' do
        post :create, params: { vehicle_inspection: {
          model_id: model.id, city_id: city.id, make_year: 1998, price: 30_000, seller_mobile_number: '7974578489', seller_country_code: '+91', advertisement_url: 'https://www.car24.com/', seller_email: 'user1@gmail.com', notes_for_the_inspector: 'this car is the best for user', inspection_amount: 670, seller_name: 'usertest', instant_deposit_amount: 100, final_sale_amount: 150, regional_spec: regional_spec.id
        },  card: { number: 5_555_555_555_554_1, month: 7, year: 2030, cvc: 898 }}
        expect(JSON.parse(response.body).keys).to eq(%w[success message])
        expect(JSON.parse(response.body)['success']).to eq(false)
      end

      it 'with car ad' do
        post :create, params: { vehicle_inspection: {
          model_id: model.id, city_id: city.id, make_year: 1998, price: 30_000, seller_mobile_number: '7974578489', seller_country_code: '+91', advertisement_url: 'https://www.car24.com/', seller_email: 'user1@gmail.com', notes_for_the_inspector: 'this car is the best for user', inspection_amount: 670, seller_name: 'usertest', instant_deposit_amount: 100, final_sale_amount: 150, regional_spec: regional_spec.id, car_ad_id: car_ad1.id
        },  card: { number: 5_555_555_555_554_444, month: 7, year: 2030, cvc: 898 }}
        # expect(JSON.parse(response.body)['data'].keys).to eq(small_keys)
        expect(JSON.parse(response.body)["success"]).to eq(true)
      end
      it 'invalid data present' do
        post :create, params: { vehicle_inspection: {
          make_year: 1998, price: 30_000, seller_mobile_number: '7974578489', seller_country_code: '+966', advertisement_url: 'https://www.car24.com/', seller_email: 'user1@gmail.com', notes_for_the_inspector: 'this car is the best for user', inspection_amount: 670, seller_name: 'usertest'
        }, card: { number: 5_555_555_555_554_444, month: 7, year: 2030, cvc: 898 } }
        # expect(JSON.parse(response.body).keys).to eq(status_keys)
        expect(JSON.parse(response.body)['success']).to eq(false)
      end
    end

    context 'create_vehicle_inspection' do
      before do
        request.headers['token'] = login_user(account)
        car_ad1.images.create(image: Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixtures', 'myfiles', 'bmw.jpeg'), 'image/jpeg'
        ))
      end
      it 'valid data is present' do
        post :create_vehicle_inspection, params: { vehicle_inspection: {
          car_ad_id: car_ad1.id, notes_for_the_inspector: 'this car is the best for user.', inspection_amount: 670
        } , card: { number: 5_555_555_555_554_444, month: 7, year: 2030, cvc: 898 } }
        expect(JSON.parse(response.body)["success"]).to eq(true)
      end

       it 'invalid inspection amount is present' do
        post :create_vehicle_inspection, params: { vehicle_inspection: {
          car_ad_id: car_ad1.id, notes_for_the_inspector: 'this car is the best for user.', inspection_amount: 0
        } , card: { number: 5_555_555_555_554_444, month: 7, year: 2030, cvc: 898 } }
        expect(JSON.parse(response.body)["success"]).to eq(false)
      end

      it 'invalid data is present' do
        post :create_vehicle_inspection, params: { vehicle_inspection: {
          notes_for_the_inspector: 'this car is the best for user car', inspection_amount: 670
        }}
        expect(JSON.parse(response.body)['status']).to eq(404)
      end

      it 'invalid params' do
        post :create_vehicle_inspection
        expect(JSON.parse(response.body)['success']).to eq(false)
        expect(JSON.parse(response.body)['message']).to eq('Required inputs missing')
      end
    end

    context 'inspection_payment_details' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        post :inspection_payment_details, params: { id: vehicle_inspection.id }
        expect(JSON.parse(response.body).keys).to eq(['order_payment_details'])
        expect(JSON.parse(response.body)['order_payment_details'].keys).to eq(%w[order_id
                                                                                 inspection_ammount total])
      end
    end

    context 'update_instant_deposit_status' do
      before do
        request.headers['token'] = login_user(account)
      end
      it 'valid data present' do
        post :update_instant_deposit_status,
             params: { id: vehicle_inspection.id,
                       vehicle_inspection: { seller_name: 'xyz', about: 'best car for user' } }
        expect(JSON.parse(response.body)['data'].keys).to eq(small_keys)
        expect(JSON.parse(response.body)['data']['type']).to eq('vehicle_inspection')
      end

      it 'invalid data present' do
        post :update_instant_deposit_status,
             params: { id: vehicle_inspection.id,
                       vehicle_inspection: { seller_name: nil, about: 'best car for user', price: '' } }
        # expect(JSON.parse(response.body).keys).to eq(status_keys)
        # expect(JSON.parse(response.body)['message']).to eq('Unable to submit. Please try again.')
      end
    end
  end
end
