require 'rails_helper'
RSpec.describe ::BxBlockProfile::AssociatedProject, type: :model do
  describe 'associations' do
    it { should belong_to(:project).class_name('BxBlockProfile::Project') }
    it { should belong_to(:associated).class_name('BxBlockProfile::Associated') }
  end
end
