require 'rails_helper'
RSpec.describe ::BxBlockCatalogue::Review, type: :model do
  describe 'associations' do
    it { should belong_to(:catalogue) }
  end
end
