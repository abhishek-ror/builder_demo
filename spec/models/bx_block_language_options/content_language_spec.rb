require 'rails_helper'
RSpec.describe ::BxBlockLanguageOptions::ContentLanguage, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:language) }
  end
end
