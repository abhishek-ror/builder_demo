require 'rails_helper'
RSpec.describe ::BxBlockAdmin::InspectionReport, type: :model do
  describe 'associations' do
    it { should belong_to(:vehicle_inspection) }
    it { should have_many(:images).class_name('BxBlockContentManagement::Image')}
    it { should have_many(:inspection_forms).class_name('BxBlockContentManagement::Image')}
    it { should have_many(:reports).class_name('BxBlockContentManagement::Image')}
    it { should accept_nested_attributes_for(:images)}
    it { should accept_nested_attributes_for(:inspection_forms)}
    it { should accept_nested_attributes_for(:reports)}

  end

  # describe '#check_push_notification' do
  #   let(:vehicle_inspection) { create(:vehicle_inspection) }
  #   let(:inspection_report) { create(:inspection_report, vehicle_inspection: vehicle_inspection) }

	 #    it 'creates a push notification when google_drive_url is updated' do
	 #      # expect {
	 #      #   inspection_report.update(google_drive_url: 'www.google.com')
	 #      # }.to change(BxBlockPushNotifications::PushNotification, :count).by(1)

	 #      push_notification = BxBlockPushNotifications::PushNotification.last
	 #      # expect(push_notification.account_id).to eq(vehicle_inspection.account_id)
	 #      # git expect(push_notification.remarks).to eq('Your inspection report has been updated')
	 #      expect(push_notification.notify_type).to eq('Inspection Report')
	 #      # expect(push_notification.push_notificable_id).to eq(vehicle_inspection.account_id)
	 #      # expect(push_notification.push_notificable_type).to eq('AccountBlock::Account')
	 #      expect(push_notification.is_read).to be(false)
	 #      # expect(push_notification.logo).to eq('your_base_url') # Replace 'your_base_url' with the expected value
	 #      expect(push_notification.notification_type).to eq('inspection updated')
	 #      # expect(push_notification.notification_type_id).to eq(vehicle_inspection.id)
	 #    end

	 #    # it 'does not create a push notification when google_drive_url is not updated' do
	 #    #   expect {
	 #    #     your_model.update(some_other_attribute: 'new_value')
	 #    #   }.not_to change(BxBlockPushNotifications::PushNotification, :count)
	 #    # end
 	# end

end