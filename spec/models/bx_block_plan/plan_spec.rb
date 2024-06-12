require 'rails_helper'
RSpec.describe ::BxBlockPlan::Plan, type: :model do
  describe 'associations' do
    it { should have_many(:user_subscriptions).class_name('BxBlockPlan::UserSubscription').dependent(:destroy)}
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:details) }
    it { should validate_presence_of(:ad_count) }
  end

  describe 'enum' do
    it { should define_enum_for(:duration) }
  end
end
