require 'rails_helper'
RSpec.describe ::BxBlockPushNotifications::PushNotification, type: :model do
	describe 'associations' do
		it { should belong_to(:push_notificable)}
		it { should belong_to(:account) }
		it { should belong_to(:created_user).with_foreign_key('created_by').optional }
		it { should have_one_attached(:logo) }
	end

	describe 'validation' do
		it { should validate_presence_of(:remarks) }
	end

  # describe '.send_push_notification' do
  #   let(:vehicle_inspection) { create(:vehicle_inspection) }
  #   let(:account) { create(:account, device_id: 'device_id', full_phone_number: "919667522324") }
  #   let(:message) { 'Test message' }
  #   let(:notify_type) { 'test' }
  #   context 'when push notification is successfully sent' do
  #     before do
  #       allow(AccountBlock::Account).to receive_message_chain(:find, :device_id).and_return(account.device_id)
  #       allow(ENV).to receive(:[]).with('FCM_SEVER_KEY').and_return('fcm_server_key')
  #       allow_any_instance_of(FCM).to receive(:send).and_return({ 'success' => 1 })
  #     end
      

      # it 'sends a push notification' do
      #   #expect(FCM).to receive(:new).with('fcm_server_key').and_call_original
      #   expect_any_instance_of(FCM).to receive(:send).with(account.device_id, {
      #     priority: 'high',
      #     data: {
      #       message: message,
      #       notify_type: notify_type,
      #       account_id: vehicle_inspection.account_id
      #     },
      #     notification: {
      #       body: message,
      #       sound: 'default'
      #     }
      #   })
      #   described_class.send_push_notification(vehicle_inspection, message, notify_type)
      # end
      
    # end

  #   context 'when an error occurs while sending push notification' do
  #     before do
  #       allow(AccountBlock::Account).to receive_message_chain(:find, :device_id).and_return(account.device_id)
  #       # allow(ENV).to receive(:[]).with('FCM_SEVER_KEY').and_return('fcm_server_key')
  #       allow_any_instance_of(FCM).to receive(:send).and_raise(StandardError)
  #     end

  #     it 'rescues the exception and returns it' do
  #       expect(described_class.send_push_notification(vehicle_inspection, message, notify_type)).to be_a(StandardError)
  #     end
  #   end
  # end

  describe '#send_push_notification' do
      let(:push_notification) { described_class.new }
      let(:account) { create(:account, fcm_device_token: 'fcm_device_token', full_phone_number: "919667522324") }
      let(:remarks) { 'Test message' }
      let(:notification_type) { 'test' }

      context 'when push_notificable is activated and has fcm_device_token' do
        let(:push_notificable) { double('PushNotificable', activated: true, fcm_device_token: 'fcm_device_token') }

        before do
          allow(push_notification).to receive(:push_notificable).and_return(push_notificable)
          allow(push_notification).to receive(:remarks).and_return(remarks)
          allow(push_notification).to receive(:notification_type).and_return(notification_type)
          allow(push_notification).to receive(:notification_type_id).and_return(push_notification.id)
          allow(push_notification).to receive(:id).and_return(push_notification.id)
          allow(push_notification).to receive(:is_inspected).and_return(push_notification.is_inspected)
          allow(push_notification).to receive(:random_key).and_return(push_notification.random_key)
        end

        it 'sends a push notification' do
          # Stubbing the AccountBlock::Account class and its method
          allow(AccountBlock::Account).to receive(:find_by).with(fcm_device_token: 'fcm_device_token').and_return(account)

          # Mocking the FCM client instance
          fcm_client = instance_double(FCM)
          allow(FCM).to receive(:new).and_return(fcm_client)

          # Expecting the FCM client's `send` method to be called
          expect(fcm_client).to receive(:send).with(['fcm_device_token'], {
            priority: 'high',
            data: {
              message: remarks,
              notification_type: notification_type,
              notification_type_id: push_notification.id,
              id: push_notification.id,
              is_inspected: push_notification.is_inspected
            },
            notification: {
              body: remarks,
              random_key: push_notification.random_key,
              sound: 'default'
            }
          })

          # Call the method and expect it to send the push notification
          push_notification.send_push_notification
        end
      end 
      context 'when an error occurs while sending push notification' do
        let(:push_notificable) { double('PushNotificable', activated: true, fcm_device_token: nil) }
          before do
            allow(AccountBlock::Account).to receive_message_chain(:find, :fcm_device_token).and_return(account.fcm_device_token)
            # allow(ENV).to receive(:[]).with('FCM_SEVER_KEY').and_return('fcm_server_key')
            allow_any_instance_of(FCM).to receive(:send).and_raise(StandardError)
          end

          it 'rescues the exception and returns it' do
            expect(push_notification.send_push_notification).to be_a(StandardError)
          end
      end
  end
end