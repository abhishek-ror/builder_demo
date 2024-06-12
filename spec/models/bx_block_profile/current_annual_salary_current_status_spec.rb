require 'rails_helper'
RSpec.describe ::BxBlockProfile::CurrentAnnualSalaryCurrentStatus, type: :model do
  describe 'associations' do
    it { should belong_to(:current_status).class_name('BxBlockProfile::CurrentStatus') }
    it { should belong_to(:current_annual_salary).class_name('BxBlockProfile::CurrentAnnualSalary') }
  end
end