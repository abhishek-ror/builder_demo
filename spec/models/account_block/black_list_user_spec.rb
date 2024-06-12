require 'rails_helper'
RSpec.describe ::AccountBlock::BlackListUser, type: :model do
  
  describe 'association' do
  	it { should belong_to(:account).class_name("AccountBlock::Account") }
  end

  # describe "instance methods" do
  #   let(:account) { create(:account) }
  #   let(:black_list_user) { create(:black_list_user) }

  #   describe "#user_mobile_number" do
  #     it "returns the full phone number of the associated account" do
  #       expect(black_list_user.user_mobile_number).to eq(account.full_phone_number)
  #     end
  #   end
  # end

  # describe "#user_email" do
  #   it "returns the email of the associated account" do
  #     expect(black_list_user.user_email).to eq(account.email)
  #   end
  # end

  # describe "#user_type" do
  #   it "returns the user type of the associated account" do
  #     expect(black_list_user.user_type).to eq(account.user_type)
  #   end
  # end

end
