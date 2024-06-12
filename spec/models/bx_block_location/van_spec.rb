require 'rails_helper'
RSpec.describe ::BxBlockLocation::Van, type: :model do
  describe 'associations' do
    it { should have_one(:location).class_name('BxBlockLocation::Location').dependent(:destroy) }
    it { should have_one(:service_provider).class_name('BxBlockLocation::VanMember').dependent(:destroy).with_foreign_key('account_id') }
    it { should have_many(:assistants).class_name('BxBlockLocation::VanMember').dependent(:destroy).with_foreign_key('account_id') }
    it { should have_many(:van_members).class_name('BxBlockLocation::VanMember').dependent(:destroy) }
    it { should have_one_attached(:main_photo) }
    it { should have_many_attached(:galleries) }
    it { should accept_nested_attributes_for(:van_members) }
    it { should accept_nested_attributes_for(:service_provider) }
    it { should accept_nested_attributes_for(:assistants) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
