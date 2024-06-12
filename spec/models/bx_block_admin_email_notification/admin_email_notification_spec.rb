require 'rails_helper'

RSpec.describe BxBlockAdminEmailNotification::AdminEmailNotification, type: :model do
	describe 'validation' do
    	it { should validate_presence_of(:content) }    
  	end
    describe 'enum' do
   		it { should define_enum_for(:notification_name) }
  	end
end
