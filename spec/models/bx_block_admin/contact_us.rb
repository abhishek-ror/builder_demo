require 'rails_helper'
RSpec.describe ::BxBlockAdmin::ContactUs, type: :model do
  
  describe 'validation' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:email) }
  end
end
