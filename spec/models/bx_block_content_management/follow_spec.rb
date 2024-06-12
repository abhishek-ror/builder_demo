require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Follow, type: :model do
  describe 'validation' do
    it { should belong_to(:account).class_name("AccountBlock::Account") }
  end
end