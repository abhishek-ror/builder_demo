
require 'rails_helper'
RSpec.describe ::BxBlockAdmin::VehicleInspection, type: :model do
 let!(:account) { create(:account) }
        let!(:plan) { create(:plan) }
        let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
        let!(:company) { create(:company) }
        let!(:model) { create(:model, company: company) }
        let!(:trim) { create(:trim, model: model) }
        let!(:region) { create(:region) }
        let!(:country) { create(:country, region: region) }
        let!(:state) { create(:state, country: country) }
        let!(:city) { create(:city, state: state) }
        let!(:regional_spec) {create(:regional_spec_data)}
        let!(:inspection_charge) { create(:inspection_charge) }
        let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
        let!(:vehicle_inspection1) { create(:vehicle_inspection, account: account, city: city, model: model) }
       
  let!(:vehicle_inspection) { create(:vehicle_inspection, account: account, city: city, model: model,car_ad: car_ad1,status: 5) }
        
  describe "update inspection" do 
    it "update_inspection_status" do 
      vehicle_inspection.update(status: 'accepted_for_inspection')
    end
    it "not update_inspection_status" do 
      vehicle_inspection.update(status: 'rejected')
    end
    it "not update_inspection_status" do 
      vehicle_inspection.update(instant_deposit_link: 'www.google.com')
    end
  end
  describe 'associations' do
    it { should belong_to(:city).optional }
    it { should belong_to(:model).optional }
    it { should belong_to(:car_ad).class_name('BxBlockAdmin::CarAd').optional.with_foreign_key('car_ad_id') }
    it { should belong_to(:inspector).class_name('AccountBlock::Account').optional.with_foreign_key('inspector_id') }
    it { should belong_to(:account).class_name('AccountBlock::Account').optional.with_foreign_key('account_id') }
    it { should belong_to(:admin_user).class_name('AdminUser').optional }
    it { should have_one(:inspection_report) }
    it { should have_one_attached(:instant_deposit_receipt) }
    it { should have_many(:images).class_name('BxBlockContentManagement::Image')}
    it { should have_one(:car_order).class_name('BxBlockOrdercreation3::CarOrder')}
    it { should accept_nested_attributes_for(:images).allow_destroy(true)}
   # it { should accept_nested_attributes_for(:inspection_report).allow_destroy(true)}
  end

  context 'attchments' do
    it { should have_one_attached(:inspection_invoice) }
    # it { should have_one_attached(:instant_deposit_link) }
    it { should have_one_attached(:final_invoice) }
  end

  describe 'delegations' do
    it { should delegate_method(:company).to(:model) }
  end

  describe 'validation' do
    it { should validate_presence_of(:city_id) }
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:model_id) }
    #it { should allow_value("Seller Name").for(:seller_name) }
    #it { should allow_value("+91").for(:seller_country_code) }
    #it { should validate_presence_of(:seller_mobile_number) }
    #it { should validate_presence_of(:seller_email) }
  end

  describe 'enum' do
    it { should define_enum_for(:status) }
    it { should define_enum_for(:acceptance_status) }
    it { should define_enum_for(:instant_deposit_status) }
    it { should define_enum_for(:final_invoice_status) }
    it { should define_enum_for(:payment_link_active) }
  end

  describe '#update_inspection_status' do
    let(:vehicle_inspection) {create(:vehicle_inspection)}

    context 'when the instant deposit status is changed and confirmed' do
      before do
        allow(vehicle_inspection).to receive(:saved_change_to_instant_deposit_status?).and_return(true)
        allow(vehicle_inspection).to receive(:instant_deposit_status_confirmed?).and_return(true)
      end


      it 'deactivates the payment link' do
        expect(vehicle_inspection).to receive(:deactivate_payment_link)
        vehicle_inspection.update_inspection_status
      end
    end

    context 'when none of the conditions are met' do
      before do
        allow(vehicle_inspection).to receive(:saved_change_to_status?).and_return(false)
        allow(vehicle_inspection).to receive(:saved_change_to_instant_deposit_status?).and_return(false)
        allow(vehicle_inspection).to receive(:saved_change_to_final_invoice_status?).and_return(false)
      end

      it 'does not update the status' do
        expect { vehicle_inspection.update_inspection_status }.not_to change { vehicle_inspection.status }
      end

      it 'does not deactivate the payment link' do
        expect(vehicle_inspection).not_to receive(:deactivate_payment_link)
        vehicle_inspection.update_inspection_status
      end
    end
  end

  describe '#generate_instant_payment_link' do
    let(:vehicle_inspection) { create(:vehicle_inspection, instant_deposit_amount: 10.0) }

    context 'when instant_deposit_amount is changed and greater than 0.0' do
      before do
        vehicle_inspection.instant_deposit_amount = 20.0
      end

      context 'when stripe_payment_link_id, instant_deposit_link, and payment_link_active are present' do
        before do
          vehicle_inspection.stripe_payment_link_id = 'stripe_payment_link_id'
          vehicle_inspection.instant_deposit_link = 'instant_deposit_link'
          vehicle_inspection.payment_link_active = 'Yes'
        end

        it 'calls deactivate_payment_link' do
          expect(vehicle_inspection).to receive(:deactivate_payment_link)
          vehicle_inspection.generate_instant_payment_link
        end

      end

      context 'when stripe_payment_link_id, instant_deposit_link, and payment_link_active are not present' do
        it 'calls create_instant_payment_link' do
          expect(vehicle_inspection).to receive(:create_instant_payment_link)
          vehicle_inspection.generate_instant_payment_link
        end
      end
    end

    context 'when instant_deposit_amount is not changed or is less than or equal to 0.0' do
      before do
        vehicle_inspection.instant_deposit_amount = 0.0
      end

      it 'does not call create_instant_payment_link' do
        expect(vehicle_inspection).not_to receive(:create_instant_payment_link)
        vehicle_inspection.generate_instant_payment_link
      end

      it 'does not call deactivate_payment_link' do
        expect(vehicle_inspection).not_to receive(:deactivate_payment_link)
        vehicle_inspection.generate_instant_payment_link
      end
    end
  end
end
