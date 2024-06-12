require 'rails_helper'
RSpec.describe ::BxBlockProfile::CurrentStatusIndustry, type: :model do
  describe 'associations' do
    it { should belong_to(:current_status).class_name('BxBlockProfile::CurrentStatus') }
    it { should belong_to(:industry).class_name('BxBlockProfile::Industry') }   
  end
end