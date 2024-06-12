require 'rails_helper'
RSpec.describe ::BxBlockAdmin::Country, type: :model do
  describe 'associations' do
    it { should belong_to(:region) }
    it { should have_many(:states) }
    it { should have_one_attached(:file) }
  end
  describe 'validation' do
    it { should validate_presence_of(:name) }
  end
end
