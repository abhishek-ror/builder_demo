require 'rails_helper'
RSpec.describe ::BxBlockLocation::Location, type: :model do
  describe 'associations' do
    it { should belong_to(:van).class_name('BxBlockLocation::Van') }
  end
end

