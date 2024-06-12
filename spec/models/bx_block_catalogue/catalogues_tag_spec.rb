require 'rails_helper'
RSpec.describe ::BxBlockCatalogue::CataloguesTag, type: :model do
  describe 'associations' do
    it { should belong_to(:catalogue) }
    it { should belong_to(:tag) }
  end
end
