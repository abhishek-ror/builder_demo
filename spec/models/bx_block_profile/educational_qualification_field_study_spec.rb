require 'rails_helper'
RSpec.describe ::BxBlockProfile::EducationalQualificationFieldStudy, type: :model do
  describe 'associations' do
    it { should belong_to(:field_study).class_name('BxBlockProfile::FieldStudy') }
    it { should belong_to(:educational_qualification).class_name('BxBlockProfile::EducationalQualification') }
  end
end