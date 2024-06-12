require 'rails_helper'
RSpec.describe ::BxBlockProfile::Profile, type: :model do
   describe 'associations' do
    it { should have_one_attached(:photo) }
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should have_one(:current_status).dependent(:destroy).class_name('BxBlockProfile::CurrentStatus') }
    it { should accept_nested_attributes_for(:current_status).allow_destroy(true) }
    it { should have_one(:publication_patent).dependent(:destroy).class_name('BxBlockProfile::PublicationPatent') }
    it { should accept_nested_attributes_for(:publication_patent).allow_destroy(true) }
    it { should have_many(:awards).dependent(:destroy).class_name('BxBlockProfile::Award') }
    it { should accept_nested_attributes_for(:awards).allow_destroy(true) }
    it { should have_many(:hobbies).dependent(:destroy).class_name('BxBlockProfile::Hobby') }
    it { should accept_nested_attributes_for(:hobbies).allow_destroy(true) }
    it { should have_many(:courses).dependent(:destroy).class_name('BxBlockProfile::Course') }
    it { should accept_nested_attributes_for(:courses).allow_destroy(true) }
    it { should have_many(:test_score_and_courses).dependent(:destroy).class_name('BxBlockProfile::TestScoreAndCourse') }
    it { should accept_nested_attributes_for(:test_score_and_courses).allow_destroy(true) }
    it { should have_many(:career_experiences).dependent(:destroy).class_name('BxBlockProfile::CareerExperience') }
    it { should accept_nested_attributes_for(:career_experiences).allow_destroy(true) }
    # it { should have_one(:video).class_name('BxBlockVideolibrary::Video') }
    it { should have_many(:educational_qualifications).dependent(:destroy).class_name('BxBlockProfile::EducationalQualification') }
    it { should accept_nested_attributes_for(:educational_qualifications).allow_destroy(true) }
     it { should have_many(:projects).dependent(:destroy).class_name('BxBlockProfile::Project') }
    it { should accept_nested_attributes_for(:projects).allow_destroy(true) }
    # it { should have_many(:languages).class_name('BxBlockProfile::Language') }
    # it { should have_many(:contacts).class_name('BxBlockContactsintegration::Contact') }
    # it { should have_many(:jobs).class_name('BxBlockJobListing::Job') }
    # it { should have_many(:applied_jobs).class_name('BxBlockJobListing::AppliedJob') }
    # it { should have_many(:follows).class_name('BxBlockJobListing::Follow') }
    # it { should have_many(:interview_schedules).class_name('BxBlockCalendar::InterviewSchedule') }
  
  end

  describe 'enums' do
    it { should define_enum_for(:profile_role).with_values(jobseeker: 0, recruiter: 1) }
  end

end