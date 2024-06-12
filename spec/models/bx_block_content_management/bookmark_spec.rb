require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Bookmark, type: :model do
  describe "associations" do
    it { should belong_to(:account).class_name("AccountBlock::Account") }
    it { should belong_to(:content).class_name("BxBlockContentManagement::Content") }
  end

  describe "validations" do
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:content_id) }
    # it { should validate_uniqueness_of(:account_id).scoped_to(:content_id).with_message("content with this account is already taken") }
  end
end