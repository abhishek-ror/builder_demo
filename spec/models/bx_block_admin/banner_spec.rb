require 'rails_helper'
RSpec.describe ::BxBlockAdmin::Banner, type: :model do
  describe 'associations' do
    it { should accept_nested_attributes_for(:image) }
    it { should have_one(:image).class_name('BxBlockContentManagement::Image')}
  end
end
