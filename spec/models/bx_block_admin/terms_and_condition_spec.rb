require 'rails_helper'
RSpec.describe ::BxBlockAdmin::TermsAndCondition, type: :model do
  
  describe 'validation' do
    it { should validate_presence_of(:description) }
  end
end
