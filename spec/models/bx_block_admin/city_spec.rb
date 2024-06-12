require 'rails_helper'
RSpec.describe ::BxBlockAdmin::City, type: :model do
  describe 'associations' do
    it { should belong_to(:state) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
  end
end
