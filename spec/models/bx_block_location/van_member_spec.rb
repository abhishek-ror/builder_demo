require 'rails_helper'
RSpec.describe ::BxBlockLocation::VanMember, type: :model do
  describe 'associations' do
    it { should belong_to(:van).class_name('BxBlockLocation::Van') }
    it { should belong_to(:account).class_name('AccountBlock::Account') }
  end
end
