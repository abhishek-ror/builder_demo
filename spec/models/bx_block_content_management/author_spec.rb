require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Author, type: :model do
	describe "associations" do
    it { should have_many(:contents).class_name("BxBlockContentManagement::Content").dependent(:destroy) }
    it { should have_one(:image).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:bio) }

    it do
      should validate_length_of(:bio).with_message("should not be greater than %{count} words")
    end
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:image).allow_destroy(true) }
  end
end