require 'rails_helper'
RSpec.describe ::BxBlockAdmin::Badge, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:car_ads) }
  end
end
