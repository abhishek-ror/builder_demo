require 'rails_helper'
RSpec.describe ::BxBlockAdmin::FlashScreen, type: :model do
  describe 'associations' do
    it { should have_many(:images) }
    it { should define_enum_for(:screen_type) }
    it { should accept_nested_attributes_for(:images) }
  end

  describe 'validation' do
    it { should validate_presence_of(:screen_type) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:offer) }
    it { should validate_presence_of(:tips_for_advertisment_posting) }
    it { should validate_presence_of(:offer_title) }
    it { should validate_presence_of(:tips_title) }
    it { should validate_presence_of(:description_title) }
  end
end
