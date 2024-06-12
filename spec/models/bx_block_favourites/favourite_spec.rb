require 'rails_helper'
RSpec.describe ::BxBlockFavourites::Favourite, type: :model do
  describe 'associations' do
    it { should belong_to(:favouriteable) }
  end
end
