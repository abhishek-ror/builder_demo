require 'rails_helper'
RSpec.describe ::BxBlockProfile::CurrentStatus, type: :model do
  describe 'associations' do
    it { should belong_to(:profile).class_name('BxBlockProfile::Profile') }
    it { should have_many(:current_status_industrys).class_name('BxBlockProfile::CurrentStatusIndustry') }
    it { should have_many(:current_status_employment_types).class_name('BxBlockProfile::CurrentStatusEmploymentType') }
    it { should have_many(:current_annual_salary_current_status).class_name('BxBlockProfile::CurrentAnnualSalaryCurrentStatus') }
  end
end