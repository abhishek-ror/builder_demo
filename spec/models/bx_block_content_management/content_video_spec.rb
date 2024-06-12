require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::ContentVideo, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:headline) }
  end

  describe "associations" do
    it { should have_one(:video).class_name('BxBlockContentManagement::Video').dependent(:destroy) }
    it { should have_one(:image).dependent(:destroy) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:image).allow_destroy(true) }
    it { should accept_nested_attributes_for(:video).allow_destroy(true) }
  end  
end