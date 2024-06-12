require 'rails_helper'
RSpec.describe ::AccountBlock::SmsAccount, type: :model do
  

  describe 'validation' do
    it { should validate_presence_of(:full_phone_number) }
    # it { should validate_uniqueness_of(:full_phone_number) }

  end

end  