require 'rails_helper'

RSpec.describe VehiclePayment, type: :model do
	describe 'associations' do
		it { should belong_to(:account).class_name('AccountBlock::Account').optional }
		it { should belong_to(:vehicle_order).class_name('BxBlockVehicleShipping::VehicleOrder').optional }
	end
	
end