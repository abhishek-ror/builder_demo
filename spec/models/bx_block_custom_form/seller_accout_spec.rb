require 'rails_helper'
RSpec.describe ::BxBlockCustomForm::SellerAccount, type: :model do
  describe "acts_as_mappable configuration" do
    it "sets the default units to kms" do
      # expect(BxBlockLocation::Location.default_units).to eq(:kms)
    end

    it "sets the default formula to sphere" do
      # expect(BxBlockLocation::Location.default_formula).to eq(:sphere)
    end

    it "sets the distance field name to distance" do
      # expect(BxBlockLocation::Location.distance_field_name).to eq(:distance)
    end

    it "sets the lat column name to lat" do
      # expect(BxBlockLocation::Location.lat_column_name).to eq(:lat)
    end

    it "sets the lng column name to long" do
      # expect(BxBlockLocation::Location.lng_column_name).to eq(:long)
    end
  end

  describe "associations" do
    # it { should belong_to(:account).class_name("AccountBlock::Account") }
  end

end