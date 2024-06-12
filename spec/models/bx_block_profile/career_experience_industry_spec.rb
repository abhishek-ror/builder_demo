require 'rails_helper'
RSpec.describe ::BxBlockProfile::CareerExperienceIndustry, type: :model do
  describe 'associations' do
    it { should belong_to(:career_experience).class_name('BxBlockProfile::CareerExperience') }
    it { should belong_to(:industry).class_name('BxBlockProfile::Industry') }
  end
end
