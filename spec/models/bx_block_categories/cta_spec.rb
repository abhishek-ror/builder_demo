require 'rails_helper'
RSpec.describe ::BxBlockCategories::Cta, type: :model do
  

  describe "associations" do
    it { should belong_to(:category) }
  end

  describe "validations" do
    # it { should validate_presence_of(:headline) }
    # it { should validate_presence_of(:text_alignment) }
    # it { should validate_presence_of(:button_text) }
    # it { should validate_presence_of(:redirect_url) }
    # it { should validate_presence_of(:button_alignment) }
  end

  describe "methods" do
    # let(:cta) { FactoryBot.create(:cta) }

    it "should return headline as name" do
      # expect(cta.name).to eq(cta.headline)
    end
  end

  describe "uploaders" do
    # it { should mount_uploader(:long_background_image) }
    # it { should mount_uploader(:square_background_image) }
  end

  describe "enums" do
    it { should define_enum_for(:text_alignment).with_values(["centre", "left", "right"]) }
    it { should define_enum_for(:button_alignment).with_suffix(true).with_values(["centre", "left", "right"]) }
  end

end