require 'rails_helper'
RSpec.describe ::AccountBlock::SocialAccount, type: :model do
  

  describe "validations" do
    subject { FactoryBot.build(:social_account) }

    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:unique_auth_id) }
  end

  describe "callbacks" do
    describe "after_validation" do
      let(:social_account) { FactoryBot.build(:social_account) }

      it "should set activated to true" do
        social_account.valid?
        expect(social_account.activated).to be true
      end
    end
  end

end  