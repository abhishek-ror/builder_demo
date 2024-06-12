require 'rails_helper'
RSpec.describe ::BxBlockNotifications::Notification, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account').with_foreign_key('account_id') }
    it { should belong_to(:created_user).class_name('AccountBlock::Account').with_foreign_key('created_by') }
  end
  describe 'validation' do
    it { should validate_presence_of(:headings) }
    it { should validate_presence_of(:contents) }
    it { should validate_presence_of(:account_id) }
  end
end
