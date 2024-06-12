require 'rails_helper'
RSpec.describe ::BxBlockAdmin::CarEngineType, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:models) }
    it { should have_and_belong_to_many(:car_ads) }
  end
end
