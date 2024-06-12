require 'rails_helper'

RSpec.describe ::BxBlockRequestManagement::Request, type: :model do

	describe '.mutual_friend' do
	    let(:current_account) { create(:account) }
	    let(:request_1) { create(:request, sender: current_account) }
		let(:request_2) { create(:request, account: current_account) }
	
		it 'does not set mutual_friends for requests with no mutual friends' do
		  BxBlockRequestManagement::Request.mutual_friend(current_account, [request_1, request_2])

		  expect(request_1.mutual_friends).to be_empty
		  expect(request_2.mutual_friends).to be_empty
		end

	end

end