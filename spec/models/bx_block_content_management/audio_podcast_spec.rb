require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::AudioPodcast, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:heading) }
  end

  describe "associations" do
    it { should have_one(:image).dependent(:destroy).class_name("Image") }
    it { should have_one(:audio).dependent(:destroy).class_name("Audio") }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:image).allow_destroy(true) }
    it { should accept_nested_attributes_for(:audio).allow_destroy(true) }
  end

end