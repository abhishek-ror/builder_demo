require 'rails_helper'
RSpec.describe ::BxBlockBulkUploading::Attachment, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should have_one_attached(:attachment) }
  end
end
