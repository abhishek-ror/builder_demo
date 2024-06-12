require 'rails_helper'
RSpec.describe ::BxBlockCatalogue::Tag, type: :model do
  describe 'associations' do
   it{ should have_and_belong_to_many(:catalogue).join_table(:catalogues_tags) }

  end
end
