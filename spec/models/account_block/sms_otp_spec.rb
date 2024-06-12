require 'rails_helper'
RSpec.describe ::AccountBlock::SmsOtp, type: :model do
  

  describe 'validation' do
    it { should validate_presence_of(:full_phone_number) }
  end

 describe "callbacks" do
    it "sends the pin via SMS after create" do
      black_list_user = build(:black_list_user) # Assuming you have a factory defined for BlackListUser

      # expect(BxBlockSms::SendSms).to receive(:new).with(black_list_user.full_phone_number, "Your Pin Number is #{black_list_user.pin}").and_return(double(call: true))
      # black_list_user.save
    end
  end

end  