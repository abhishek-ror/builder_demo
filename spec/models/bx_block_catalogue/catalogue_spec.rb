require 'rails_helper'
RSpec.describe ::BxBlockCatalogue::Catalogue, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('BxBlockCategories::Category').with_foreign_key('category_id') }
    it { should belong_to(:sub_category).class_name('BxBlockCategories::SubCategory').with_foreign_key('sub_category_id') }
    it { should belong_to(:brand).optional }
    it { should have_many_attached(:images) }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:catalogue_variants).dependent(:destroy) }
    it { should have_and_belong_to_many(:tags).join_table(:catalogues_tags) }
    it { should accept_nested_attributes_for(:catalogue_variants).allow_destroy(true) }
  end
  describe 'enum' do
    it { should define_enum_for(:availability) }
  end
end
