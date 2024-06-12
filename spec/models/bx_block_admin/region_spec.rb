require 'rails_helper'
RSpec.describe ::BxBlockAdmin::Region, type: :model do
  describe 'associations' do
    it { should have_many(:countries) }
    it { should have_one(:image).class_name('BxBlockContentManagement::Image') }
    it { should accept_nested_attributes_for(:countries).allow_destroy(true) }
    it { should accept_nested_attributes_for(:image).allow_destroy(true) }
  end
  describe 'validation' do
    it { should validate_presence_of(:name) }
  end
end
