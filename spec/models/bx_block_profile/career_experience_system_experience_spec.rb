require 'rails_helper'
RSpec.describe ::BxBlockProfile::CareerExperienceSystemExperience, type: :model do
  describe 'associations' do
    it { should belong_to(:career_experience).class_name('BxBlockProfile::CareerExperience') }
    it { should belong_to(:system_experience).class_name('BxBlockProfile::SystemExperience') }
  end
end
