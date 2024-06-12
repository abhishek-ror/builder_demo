require 'rails_helper'
RSpec.describe ::BxBlockRateCard::ShippingCharge, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:source_country) }
    it { should validate_presence_of(:destination_country) }
    it { should validate_presence_of(:destination_port) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:in_transit) }
  end
end
