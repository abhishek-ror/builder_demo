require 'rails_helper'
RSpec.describe ::BxBlockProfile::CareerExperience, type: :model do
  describe 'associations' do
    it { should belong_to(:profile).class_name('BxBlockProfile::Profile') }
    it { should have_many(:career_experience_industrys).class_name('BxBlockProfile::CareerExperienceIndustry') }
    it { should have_many(:career_experience_employment_types).class_name('BxBlockProfile::CareerExperienceEmploymentType') }
    it { should have_many(:career_experience_system_experiences).class_name('BxBlockProfile::CareerExperienceSystemExperience') }
  end
end
