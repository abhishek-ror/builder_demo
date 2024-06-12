require 'rails_helper'
RSpec.describe ::BxBlockProfile::FieldStudy, type: :model do
  describe 'associations' do
    it { should have_many(:educational_qualification_field_studys).class_name('BxBlockProfile::EducationalQualificationFieldStudy') }
  end
end