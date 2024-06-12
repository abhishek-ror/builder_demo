require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::ContentText, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:headline) }
    it { should validate_presence_of(:content) }

  end

  describe "associations" do
    it { should have_many(:videos).class_name('BxBlockContentManagement::Video').dependent(:destroy) }
    it { should have_many(:images).dependent(:destroy) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:images).allow_destroy(true) }
    it { should accept_nested_attributes_for(:videos).allow_destroy(true) }
  end
  
end