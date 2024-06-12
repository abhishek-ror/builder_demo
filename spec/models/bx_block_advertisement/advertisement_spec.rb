require 'rails_helper'
RSpec.describe ::BxBlockAdvertisement::Advertisement, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:image) }
  end
end
