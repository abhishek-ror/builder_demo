require 'rails_helper'

RSpec.describe BxBlockVehicleShipping::VehicleSelling, type: :model do
  context 'associations' do
    it { should belong_to(:city).class_name('BxBlockAdmin::City').optional }
    it { should belong_to(:account).class_name('AccountBlock::Account').optional }
    it { should belong_to(:region).class_name('BxBlockAdmin::Region').optional }
    it { should belong_to(:country).class_name('BxBlockAdmin::Country').optional }
    it { should belong_to(:state).class_name('BxBlockAdmin::State').optional }
    it { should have_many(:images).class_name('BxBlockContentManagement::Image')}
    # it { should have_many(:vehicle_order).class_name('VehicleOrder')}
  end
  
  
end