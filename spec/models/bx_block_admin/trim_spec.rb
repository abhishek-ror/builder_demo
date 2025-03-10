require 'rails_helper'
RSpec.describe ::BxBlockAdmin::Trim, type: :model do
  describe 'associations' do
    it { should belong_to(:model)}
    it { should have_many(:car_ads).dependent(:destroy) }
  end
  describe 'validations' do
    it { should validate_presence_of(:name)}
  end

end
