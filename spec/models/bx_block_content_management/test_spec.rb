require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Test, type: :model do

  describe "validations" do
    it { should validate_presence_of(:headline) }
    it { should validate_presence_of(:description) }    
  end  
end