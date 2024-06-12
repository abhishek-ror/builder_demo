require 'rails_helper'
RSpec.describe ::BxBlockProfile::EmploymentType, type: :model do
  describe 'associations' do
   it { should have_many(:current_status_employment_types).class_name('BxBlockProfile::CurrentStatusEmploymentType') } 
   it { should have_many(:career_experience_employment_types).class_name('BxBlockProfile::CareerExperienceEmploymentType') }  
  end
end