require 'rails_helper'
RSpec.describe ::BxBlockProfile::Associated, type: :model do
  describe 'associations' do
    it { should have_many(:associated_projects).class_name('BxBlockProfile::AssociatedProject') }
  end

end
