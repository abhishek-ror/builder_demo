require 'rails_helper'
RSpec.describe ::BxBlockProfile::CurrentAnnualSalary, type: :model do
  describe 'associations' do
    it { should has_many(:current_annual_salary_current_status).class_name('BxBlockProfile::CurrentAnnualSalaryCurrentStatus') }
  end
end
