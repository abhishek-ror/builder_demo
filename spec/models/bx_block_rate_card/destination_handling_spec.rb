require 'rails_helper'
RSpec.describe ::BxBlockRateCard::DestinationHandling, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:destination_country) }
    it { should validate_presence_of(:unloading) }
    it { should validate_presence_of(:customs_clearance) }
    it { should validate_presence_of(:storage) }
  end
end
