require 'rails_helper'
RSpec.describe ::BxBlockProfile::EducationalQualification, type: :model do
  describe 'associations' do
    it { should belong_to(:profile).class_name('BxBlockProfile::Profile') }
   it { should have_many(:degree_educational_qualifications).class_name('BxBlockProfile::DegreeEducationalQualification') } 
   it { should have_many(:educational_qualification_field_studys).class_name('BxBlockProfile::EducationalQualificationFieldStudy') }  
  end
end