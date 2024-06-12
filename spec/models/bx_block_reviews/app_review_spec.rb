require 'rails_helper'

RSpec.describe BxBlockReviews::AppReview, type: :model do
  let(:account) { create(:account) }

  describe 'validations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should validate_presence_of(:rating).with_message('Please provide a rating') }
    it { should validate_inclusion_of(:rating).in_range(1..5).with_message('must be between 1 and 5') }
  end

  describe 'associations' do
    it 'belongs to an account' do
      review = BxBlockReviews::AppReview.new(rating: 4, account: account)
      expect(review.account).to eq(account)
    end
  end
end