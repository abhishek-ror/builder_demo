require 'rails_helper'

RSpec.describe BxBlockShipment::UserReview, type: :model do

  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:shipment).class_name('BxBlockShipment::Shipment') }
  end
  
end