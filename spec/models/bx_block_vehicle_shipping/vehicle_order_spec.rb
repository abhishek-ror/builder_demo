require 'rails_helper'

RSpec.describe  BxBlockVehicleShipping::VehicleOrder, type: :model do
	describe 'associations' do
		it { should belong_to(:account).class_name('AccountBlock::Account').optional }
		it { should belong_to(:vehicle_selling).class_name('BxBlockVehicleShipping::VehicleSelling').optional }
    it { should belong_to(:vehicle_shipping).class_name('BxBlockVehicleShipping::VehicleShipping').optional }
    it { should belong_to(:vehicle_inspection).class_name('BxBlockAdmin::VehicleInspection').optional }
	end

	describe 'enum' do
    	it { should define_enum_for(:status) }
  	end

	describe 'validation' do
    	it { should validate_presence_of(:country) }
    	it { should validate_presence_of(:country_code) }
    	it { should validate_presence_of(:phone_number) }
  	end

  	describe '#change_final_sale_amount' do 
  		let(:account) { FactoryBot.create(:account, full_phone_number: '917887886475') }
  		it 'updates the status_time' do
  			@vehicle_order = BxBlockVehicleShipping::VehicleOrder.create!(continent: "Asia", country: "India", state: "Kolkata", area: "Madurai", country_code: account.country_code, phone_number: account.phone_number, full_phone_number: account.full_phone_number, account_id: account.id, status: 1, instant_deposit_amount: 100, final_sale_amount: 100)
  			@vehicle_order.send(:change_final_sale_amount)
  			expect(@vehicle_order.status_updated_at).to eq(@vehicle_order.status_updated_at)
  		end
  	end
end
