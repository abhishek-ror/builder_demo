require 'rails_helper'
RSpec.describe ::BxBlockRateCard::InspectionCharge, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:region) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:price) }
  end
end
