require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Audio, type: :model do
  describe 'associations' do
    it { should belong_to(:attached_item) }
    it { should validate_presence_of(:audio) }
  end
end