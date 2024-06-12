require 'rails_helper'
RSpec.describe ::BxBlockAdmin::Extra, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:car_ads) }
  end
  
  describe 'validation' do
    it { should validate_presence_of(:name) }
  end
end
