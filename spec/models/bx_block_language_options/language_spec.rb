require 'rails_helper'
RSpec.describe ::BxBlockLanguageOptions::Language, type: :model do
  describe 'associations' do
    it { should have_many(:contents_languages).class_name('BxBlockLanguageOptions::ContentLanguage').join_table('contents_languages').dependent(:destroy) }
    it { should have_many(:accounts).class_name('AccountBlock::Account').through('contents_languages').join_table('contents_languages') }
  end
end
