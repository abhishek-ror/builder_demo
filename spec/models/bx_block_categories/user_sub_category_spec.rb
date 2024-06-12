require 'rails_helper'
RSpec.describe ::BxBlockCategories::UserSubCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:sub_category) }  	
  end
end