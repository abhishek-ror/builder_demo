require 'rails_helper'
RSpec.describe ::BxBlockAdmin::Model, type: :model do
  describe 'associations' do
    it { should belong_to(:company)}
    it { should have_many(:trims).dependent(:destroy) }
    it { should have_many(:car_ads).through(:trims) }
    it { should have_and_belong_to_many(:car_engine_types) }
    describe 'validations' do
      it { should validate_presence_of(:name)}
    end

    describe 'enums' do
      it "check enum is valid" do
         should define_enum_for(:autopilot_type).with_values("No Driving Automation": 0, "Driver Assistance": 1, "Partial Driving Automation": 2, "Conditional Driving Automation": 3, "High Driving Automation": 4)
      end
    end

  end
end
