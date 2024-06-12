require 'rails_helper'
RSpec.describe ::BxBlockProfile::Industry, type: :model do
  describe 'associations' do
   it { should have_many(:current_status_industrys).class_name('BxBlockProfile::CurrentStatusIndustry') } 
   it { should have_many(:career_experience_industrys).class_name('BxBlockProfile::CareerExperienceIndustry') }  
  end
end