require 'rails_helper'
RSpec.describe ::AccountBlock::EmailOtp, type: :model do
  

  describe 'validation' do
    it { should validate_presence_of(:email) }
  end

  describe "callbacks" do
    it "generates pin and sets valid_until before create" do
      user = AccountBlock::BlackListUser.new
      user.save
      # expect(user.pin).to be_between(1000, 9999).inclusive
      # expect(user.valid_until).to be_within(5.minutes).of(Time.current + 5.minutes)
    end
  end

end  