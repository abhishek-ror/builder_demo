require 'rails_helper'
RSpec.describe ::BxBlockProfile::Project, type: :model do
  describe 'associations' do
    it { should belong_to(:profile).class_name('BxBlockProfile::Profile') }
    it { should have_many(:associated_projects).class_name('BxBlockProfile::AssociatedProject') }
  end
end