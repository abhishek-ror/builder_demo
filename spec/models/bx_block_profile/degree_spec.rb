require 'rails_helper'
RSpec.describe ::BxBlockProfile::Degree, type: :model do
  describe 'associations' do
    it { should have_many(:degree_educational_qualifications).class_name('BxBlockProfile::DegreeEducationalQualification') }    
  end
end