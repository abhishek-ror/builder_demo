require 'rails_helper'
RSpec.describe ::BxBlockProfile::CurrentStatusEmploymentType, type: :model do
  describe 'associations' do
    it { should belong_to(:current_status).class_name('BxBlockProfile::CurrentStatus') }
    it { should belong_to(:employment_type).class_name('BxBlockProfile::EmploymentType') }   
  end
end