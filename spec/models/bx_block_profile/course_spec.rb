require 'rails_helper'
RSpec.describe ::BxBlockProfile::Course, type: :model do
  describe 'associations' do
    it { should belong_to(:profile).class_name('BxBlockProfile::Profile') }
  end
  describe 'validation' do
    it { should validate_presence_of(:profile_id) }
  end
end
