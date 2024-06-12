require 'rails_helper'
RSpec.describe ::BxBlockProfile::PublicationPatent, type: :model do
  describe 'associations' do
   it { should belong_to(:profile).class_name('BxBlockProfile::Profile') }   
  end
end