require 'rails_helper'
RSpec.describe ::BxBlockLike::Like, type: :model do
  describe 'associations' do
    it { should belong_to(:likeable) }
  end

  # describe '#create_notification' do
  #   let(:like) { FactoryBot.create(:like) }
  #   # let(:likeable) { FactoryBot.create(:post) }
  #   let(:account) { FactoryBot.create(:account) }

  #   it 'creates a push notification' do
  #     expect {
  #       like.create_notification
  #     }.to change(BxBlockPushNotifications::PushNotification, :count).by(1)
  #   end

  #   it 'sets the correct attributes for the push notification' do
  #     like.create_notification
  #     push_notification = BxBlockPushNotifications::PushNotification.last

  #     expect(push_notification.account_id).to eq(like.like_by_id)
  #     expect(push_notification.push_notificable_type).to eq('AccountBlock::Account')
  #     # expect(push_notification.push_notificable_id).to eq(likeable.id)
  #     expect(push_notification.remarks).to eq("#{account.first_name} #{account.last_name} liked your post")
  #   end
  # end
  
end
