require 'rails_helper'
RSpec.describe ::BxBlockCatalogue::CatalogueVariant, type: :model do
  describe 'associations' do
    it { should belong_to(:catalogue) }
    it { should belong_to(:catalogue_variant_color).optional }
    it { should belong_to(:catalogue_variant_size).optional }
    it { should have_many_attached(:images) }
  end
end
