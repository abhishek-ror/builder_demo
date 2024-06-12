require 'rails_helper'
RSpec.describe ::BxBlockProfile::CareerExperienceEmploymentType, type: :model do
  describe 'associations' do
    it { should belong_to(:career_experience).class_name('BxBlockProfile::CareerExperience') }
    it { should belong_to(:employment_type).class_name('BxBlockProfile::EmploymentType') }
  end
end
