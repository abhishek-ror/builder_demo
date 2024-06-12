require 'rails_helper'
RSpec.describe ::BxBlockProfile::SystemExperience, type: :model do
  describe 'associations' do
   it { should have_many(:career_experience_system_experiences).class_name('BxBlockProfile::CareerExperienceSystemExperience') }   
  end
end