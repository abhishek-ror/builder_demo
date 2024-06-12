require 'rails_helper'
RSpec.describe ::BxBlockAdmin::State, type: :model do
  describe 'associations' do
    it { should belong_to(:country) }
    it { should have_many(:cities) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
  end
end
