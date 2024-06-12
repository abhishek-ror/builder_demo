require 'rails_helper'
RSpec.describe ::BxBlockAdmin::SellerType, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:car_ads) }
  end
end
