require 'rails_helper'
RSpec.describe ::BxBlockPlan::UserSubscription, type: :model do
  describe 'associations' do
    it { should have_many(:car_ads).class_name('BxBlockAdmin::CarAd') }
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:plan).class_name('BxBlockPlan::Plan') }
  end

  describe 'validation' do
    it { should validate_presence_of(:status) }
  end

  describe 'enum' do
    it { should define_enum_for(:status) }
  end
end
