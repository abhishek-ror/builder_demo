require 'rails_helper'
RSpec.describe ::BxBlockProfile::DegreeEducationalQualification, type: :model do
  describe 'associations' do
    it { should belong_to(:degree).class_name('BxBlockProfile::Degree') }
    it { should belong_to(:educational_qualification).class_name('BxBlockProfile::EducationalQualification') }   
  end
end