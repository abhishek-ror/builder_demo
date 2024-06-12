require 'rails_helper'

RSpec.describe BxBlockPushNotifications::PushNotificationsController, type: :controller do
  let(:current_user) { create(:account) }
  let(:token) { BuilderJsonWebToken.encode(current_user.id, { account_type: current_user.type }, 1.year.from_now) }

  before do
    request.headers['token'] = token
  end

  describe 'POST #create' do
    let(:valid_params) { { data: { attributes: { push_notificable_id: current_user.id, push_notificable_type: 'AccountBlock::Account', remarks: 'Notification', is_read: false, notify_type: 'AccountBlock::Account' } } } }

    context 'when valid parameters are provided' do
      it 'creates a new push notification' do
        post :create, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('data')
        expect(JSON.parse(response.body)['data']).to be_an(Hash)
      end
    end

    context 'when invalid parameters are provided' do
      let(:invalid_params) { { data: { attributes: { push_notificable_id: '', push_notificable_type: '', remarks: '', is_read: false, notify_type: '' } } } }

      it 'returns an error message' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors')
        expect(JSON.parse(response.body)['errors']).to be_an(Array)
      end
    end

    context 'when an exception occurs during create' do
      before do
        allow_any_instance_of(BxBlockPushNotifications::PushNotification).to receive(:save).and_raise(Exception, 'Custom exception message')
      end
      
      it 'returns an error message' do
        expect {
          post :create, params: valid_params
        }.not_to change(BxBlockPushNotifications::PushNotification, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors')
        expect(JSON.parse(response.body)['errors']).to be_an(Array)
        expect(JSON.parse(response.body)['errors'].first['push_notification']).to include('Custom exception message')
      end
    end
  end

  describe 'GET #show' do
    context 'when the push notification exists' do
      before do
        @vehicle_shipping = FactoryBot.create(:vehicle_shipping)
        @notification = BxBlockPushNotifications::PushNotification.create(account_id: current_user.id, remarks: "Your final invoice has been generated. Tap to view.", notify_type: "Push Notification", push_notificable_id: current_user.id, push_notificable_type: "AccountBlock::Account", is_read: false, logo: @base_url, notification_type: "vehicle payment invoice", notification_type_id: @vehicle_shipping.id)
      end
      it 'returns the push notification' do
        get :show, params: { id: @notification.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('data')
        expect(JSON.parse(response.body)['data']).to be_an(Hash)
      end
    end

    context 'when the push notification does not exist' do
      it 'returns an error message' do
        invalid_id = 123456
        get :show, params: { id: invalid_id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #get_notifications_list' do
    
    # context 'when push notifications exist' do
    #   before do
    #     FactoryBot.create(:push_notification, account_id: current_user.id, push_notificable_id: current_user.id)
    #   end
    #   it 'returns a list of push notifications' do
    #     get :get_notifications_list
    #     expect(response).to have_http_status(:ok)
    #     expect(JSON.parse(response.body)).to include('notifications')
    #     expect(JSON.parse(response.body)['notifications']).to be_an(Array)
    #   end
    # end

    context 'when there are no push notifications' do
      it 'returns a message indicating no notifications found' do
        get :get_notifications_list
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message')
        expect(JSON.parse(response.body)['message']).to eq('NO Notification Found')
      end
    end
  end
end
