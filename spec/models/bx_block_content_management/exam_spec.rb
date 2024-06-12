require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Exam, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:heading) }    
  end
end