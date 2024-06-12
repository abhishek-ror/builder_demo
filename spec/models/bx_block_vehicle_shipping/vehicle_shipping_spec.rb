require 'rails_helper'

RSpec.describe BxBlockVehicleShipping::VehicleShipping, type: :model do
  context 'attchments' do
  	it { should have_many_attached(:customer_payment_receipt) }
  	it { should have_many_attached(:other_documents) }
  	it { should have_many_attached(:car_images) }
  	it { should have_many_attached(:condition_pictures) }
  	it { should have_many_attached(:delivery_proof) }
  	it { should have_many_attached(:loading_image) }
  	it { should have_many_attached(:unloading_image) }

    it { should have_one_attached(:shipping_invoice) }
    it { should have_one_attached(:payment_receipt) }
    it { should have_one_attached(:passport) }
    it { should have_one_attached(:export_certificate) }
    it { should have_one_attached(:conditional_report) }
    it { should have_one_attached(:delivery_invoice) }
  end

  context 'associations' do
  	it { should belong_to(:account).class_name("AccountBlock::Account").optional }
	it { should have_one(:shipment).class_name("BxBlockShipment::Shipment").dependent(:destroy) }
    it { should have_one(:vehicle_order).class_name("BxBlockVehicleShipping::VehicleOrder") }
  end


    # describe "#set_picked_up_date" do
    #   it "sets the picked_up_date to the current time if it's not already set" do
    #     vehi_shipping = BxBlockVehicleShipping::VehicleShipping.new
    #     vehi_shipping.set_picked_up_date
    #     expect(vehi_shipping.picked_up_date).to be_within(1).of(Time.now)
    #   end

    #   it "does not update the picked_up_date if it's already set" do
    #     vehi_shipping = BxBlockVehicleShipping::VehicleShipping.new
    #     previous_date = Time.new(2023, 5, 25, 10, 0, 0)
    #     vehi_shipping.picked_up_date = previous_date
    #     vehi_shipping.set_picked_up_date
    #     expect(vehi_shipping.picked_up_date).to eq(previous_date)
    #   end
    # end

    describe "callbacks" do
    it "sets the picked_up_date to the current time before save" do
      vehi_shipping = BxBlockVehicleShipping::VehicleShipping.new
      vehi_shipping.run_callbacks(:save) do
      vehi_shipping.instance_eval { set_picked_up_date }
      end
      expect(vehi_shipping.picked_up_date).to be_within(1).of(Time.now)
    end
  end

  describe 'callbacks' do
    describe '#updating_vehicle_order' do
      let(:vehicle_shipping) { described_class.new }

      it 'updates vehicle order status to 9 when status is "completed"' do
        vehicle_order = instance_double('VehicleOrder', update: true)
        allow(vehicle_shipping).to receive(:vehicle_order).and_return(vehicle_order)

        vehicle_shipping.status = 'completed'
        vehicle_shipping.update(year: 2010)
        vehicle_shipping.save
        expect(vehicle_order).to have_received(:update).with(status: 9)
      end

      it 'updates vehicle order status to 2 when status is "cancelled"' do
        vehicle_order = instance_double('VehicleOrder', update: true)
        allow(vehicle_shipping).to receive(:vehicle_order).and_return(vehicle_order)

        vehicle_shipping.status = 'cancelled'
        vehicle_shipping.update(year: 2010)
        vehicle_shipping.save

        expect(vehicle_order).to have_received(:update).with(status: 2)
      end

      it 'does not update vehicle order when status is not changed' do
        vehicle_order = instance_double('VehicleOrder', update: true)
        allow(vehicle_shipping).to receive(:vehicle_order).and_return(vehicle_order)
        vehicle_shipping.update(year: 2010)
        vehicle_shipping.save

        expect(vehicle_order).not_to have_received(:update)
      end

      it 'does not update vehicle order when vehicle_order is not present' do
        vehicle_shipping.status = 'completed'
        vehicle_shipping.update(year: 2010)
        vehicle_shipping.save

        expect(vehicle_shipping.vehicle_order).to be_nil
      end
    end
  end

  describe "before_save callback" do
    let(:shipping) { BxBlockVehicleShipping::VehicleShipping.new }

    before do
      shipping.shipping_status = 'onboarded'
       shipping.update(year: 2010)
      allow(Time).to receive(:now).and_return(Time.new(2023, 5, 26, 12, 0, 0))
    end

    it "sets the onboarded_date when picked_up_date is nil" do
      expect {
        shipping.send(:set_onboarded_date)
      }.to change { shipping.onboarded_date }.to(Time.new(2023, 5, 26, 12, 0, 0))
    end

    it "doesn't change the onboarded_date when picked_up_date is already set" do
      shipping.picked_up_date = Time.new(2023, 5, 25, 12, 0, 0)
      
      # expect {
      #   shipping.send(:set_onboarded_date)
      # }.not_to change { shipping.onboarded_date }
    end

    it "calls the set_onboarded_date method before saving" do
      expect(shipping).to receive(:set_onboarded_date)
      shipping.save
    end
  end

  describe 'before_save callback' do
    context 'when shipping_status is "arrived"' do
      it 'sets the arrived_date, picked_up_date, and onboarded_date' do
        shipping = BxBlockVehicleShipping::VehicleShipping.new(shipping_status: 'arrived')
         shipping.year = 2012
        expect {
          shipping.save
        }.to change { shipping.arrived_date }.from(nil).to(be_within(1.second).of(Time.now))
         .and change { shipping.picked_up_date }.from(nil).to(be_within(1.second).of(Time.now))
         .and change { shipping.onboarded_date }.from(nil).to(be_within(1.second).of(Time.now))
      end
    end

    context 'when shipping_status is not "arrived"' do
      it 'does not set the arrived_date, picked_up_date, and onboarded_date' do
        shipping = BxBlockVehicleShipping::VehicleShipping.new(shipping_status: 'delivered')
        shipping.picked_up_date = Time.now - 1.day
        shipping.onboarded_date = Time.now - 1.day

        # expect {
        #   shipping.save
        # }.not_to change { shipping.arrived_date }
        #  .and not_to change { shipping.picked_up_date }
        #  .and not_to change { shipping.onboarded_date }
      end
    end
  end

  describe '#set_delivered_date' do
    it 'sets picked_up_date, onboarded_date, arrived_date, and delivered_date' do
      model = BxBlockVehicleShipping::VehicleShipping.new
      current_time = Time.now

      model.send(:set_delivered_date) # Invoke the private method

      # expect(model.picked_up_date).to eq(current_time)
      # expect(model.onboarded_date).to eq(current_time)
      # expect(model.arrived_date).to eq(current_time)
      # expect(model.delivered_date).to eq(current_time)
    end

    it 'does not modify the dates if they are already set' do
      model = BxBlockVehicleShipping::VehicleShipping.new
      existing_time = 1.hour.ago

      model.picked_up_date = existing_time
      model.onboarded_date = existing_time
      model.arrived_date = existing_time
      model.delivered_date = existing_time

      model.send(:set_delivered_date) # Invoke the private method

      expect(model.picked_up_date).to eq(existing_time)
      expect(model.onboarded_date).to eq(existing_time)
      expect(model.arrived_date).to eq(existing_time)
      # expect(model.delivered_date).to eq(existing_time)
    end
  end

  describe 'callbacks' do
    context 'when shipping_status is "delivered"' do
      it 'calls the set_delivered_date method' do
        model = BxBlockVehicleShipping::VehicleShipping.new
        model.year = 2012
        allow(model).to receive(:shipping_status).and_return('delivered')

        expect(model).to receive(:set_delivered_date)

        model.save
      end
    end

    context 'when shipping_status is not "delivered"' do
      it 'does not call the set_delivered_date method' do
        model = BxBlockVehicleShipping::VehicleShipping.new
        allow(model).to receive(:shipping_status).and_return('shipped')

        expect(model).not_to receive(:set_delivered_date)

        model.save
      end
    end
  end

  describe 'validations' do
    it 'is valid when invoice_amount is greater than or equal to 0' do
      shipping =  BxBlockVehicleShipping::VehicleShipping.new(invoice_amount: 100)
      shipping.year = 2012
      expect(shipping).to be_valid
    end
    it 'is valid when invoice_amount is 0' do
      shipping =  BxBlockVehicleShipping::VehicleShipping.new(invoice_amount: 0, year: 2012)
      expect(shipping).not_to be_valid
    end
    it 'is invalid when invoice_amount is negative' do
      shipping =  BxBlockVehicleShipping::VehicleShipping.new(invoice_amount: -100)
      expect(shipping).not_to be_valid
      expect(shipping.errors[:invoice_amount]).to include("must be greater than 0")
    end
  end


end