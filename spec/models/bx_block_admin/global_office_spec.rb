require 'rails_helper'
RSpec.describe ::BxBlockAdmin::GlobalOffice, type: :model do
  describe 'associations' do
    it { should belong_to(:city).class_name('BxBlockAdmin::City')}
  end
  describe 'delegations' do
    it { should delegate_method(:state).to(:city) }
    it { should delegate_method(:country).to(:state) }
  end
end
