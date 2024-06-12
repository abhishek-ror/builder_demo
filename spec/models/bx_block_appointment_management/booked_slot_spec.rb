require 'rails_helper'
RSpec.describe ::BxBlockAppointmentManagement::BookedSlot, type: :model do
  describe 'associations' do
    it { should belong_to(:service_provider).class_name('AccountBlock::Account') }
  end
end