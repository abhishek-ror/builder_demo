require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Video, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:video) }
  end

  describe "associations" do
    it { should belong_to(:attached_item) }
  end
end