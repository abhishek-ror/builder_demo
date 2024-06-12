require 'rails_helper'
RSpec.describe ::BxBlockAdmin::CarAd, type: :model do
  describe 'associations' do
    it { should belong_to(:city) }
    it { should belong_to(:trim) }
    it { should belong_to(:account).class_name('AccountBlock::Account').optional.with_foreign_key('account_id') }
    it { should belong_to(:admin_user).class_name('AdminUser').optional }
    it { should belong_to(:user_subscription).class_name('BxBlockPlan::UserSubscription').optional }
    it { should have_many(:car_orders).class_name('BxBlockOrdercreation3::CarOrder').with_foreign_key('car_ad_id') }
    it { should have_many(:images).class_name('BxBlockContentManagement::Image') }
    it { should have_many(:favourites).class_name('BxBlockFavourites::Favourite') }
    it { should have_one(:vehicle_inspection).class_name('BxBlockAdmin::VehicleInspection') }
    it { should have_and_belong_to_many(:features) }
    it { should have_and_belong_to_many(:extras) }
    it { should have_and_belong_to_many(:badges) }
    it { should have_and_belong_to_many(:regional_specs) }
    it { should have_and_belong_to_many(:colors) }
    it { should have_and_belong_to_many(:car_engine_types) }
    it { should have_and_belong_to_many(:seller_types) }
    it { should accept_nested_attributes_for(:images).allow_destroy(true)}
  end

  describe 'validations' do
    it { should validate_presence_of(:account_id) }
  end

  describe 'delegations' do
    it { should delegate_method(:model).to(:trim) }
  end

  describe 'enums' do
    STATUSES = { "drafted": 0, "posted": 1, "sold": 2, "deleted": 3 }
    TRANSMISSIONS = { "manual": 0, "cvt": 1, "dct": 2, "imt": 2 }.freeze
    AD_TYPES = { "general": 0, "top_deals": 1, "featured": 2 }
    STEERING_SIDES = { "left": 1, "right": 2 }.freeze
    it "check enum is valid" do
       should define_enum_for(:status).with_values(STATUSES)
       should define_enum_for(:transmission).with_values(TRANSMISSIONS)
       should define_enum_for(:steering_side).with_values(STEERING_SIDES)
       should define_enum_for(:ad_type).with_values(AD_TYPES)
       should define_enum_for(:car_type).with_values(new_car: 1, used_car: 2)
       should define_enum_for(:warranty).with_values("Yes"=>1, "No"=>2, "Does not apply"=>3)
    end
  end
end