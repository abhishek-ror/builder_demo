require 'rails_helper'
RSpec.describe ::BxBlockEmailNotifications::EmailNotification, type: :model do
  describe 'associations' do
    it { should belong_to(:notification).class_name('BxBlockNotifications::Notification') }
  end
end
